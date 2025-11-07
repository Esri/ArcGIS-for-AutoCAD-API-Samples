using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.Colors;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.EditorInput;
using Autodesk.AutoCAD.Geometry;
using Autodesk.AutoCAD.Runtime;
using Autodesk.Civil.DatabaseServices;
using System.Text.RegularExpressions;
using AFASamples;
using AFA = Esri.ArcGISForAutoCAD;

[assembly: CommandClass(typeof(AlignmentToMPolyline))]

namespace AFASamples
{
  class AlignmentToMPolyline
  {

    /// <summary>
    /// This sample command demonstrates how to use the ArcGIS For AutoCAD M-values API to turn a horizontal alignment into an M-enabled GIS feature.
    /// The M-values of the resultant feature represent the alignment's stationing information.
    /// The resultant feature can then be tracked as part of a document feature layer or shared to an ArcGIS portal.
    /// </summary>
    [CommandMethod("AFA_Samples_AlignmentToMPolyline")]
    public void GenerateFeatureFromAlignment()
    {
      Document doc = Application.DocumentManager.MdiActiveDocument;
      using (doc.LockDocument())
      {
        // First create a CAD layer to place the generated features
        CreateCadLayerForAlignmentFeatures(doc);

        using (var trans = doc.Database.TransactionManager.StartTransaction())
        {
          try
          {
            // Prompt the user to select an alignment
            var result = doc.Editor.GetEntity(new PromptEntityOptions("Select an Alignment entity"));
            if (result?.ObjectId == null)
              return;

            var alignment = result.ObjectId.GetObject(OpenMode.ForRead) as Alignment;

            if (alignment == null)
              return;

            // Get the alignment geometry as a polyline2d entity
            var pline2d = GetAlignmentAsPolyline2d(alignment, doc, trans);

            // Save the stationing information down to the vertices as M-values
            SetMValuesFromStations(alignment, pline2d, trans, doc);

            // Create a document feature layer to track the new features.
            CreateFeatureLayer(doc);
          }
          catch (System.Exception ex)
          {
            doc.Editor.WriteMessage(ex.Message);
          }
          finally
          {
            trans.Commit();
          }
        }
      }
    }

    /// <summary>
    /// Gets the alignment geometry as a polyline2d.
    /// </summary>
    /// <param name="alignment"></param>
    /// <param name="doc"></param>
    /// <param name="trans"></param>
    /// <returns></returns>
    private static Polyline2d GetAlignmentAsPolyline2d(Alignment alignment, Document doc, Transaction trans)
    {
      if (doc == null || alignment == null)
        throw new System.Exception("Parameters invalid");

      var plineOid = alignment.GetPolyline();
      var obj = plineOid.GetObject(OpenMode.ForWrite) as Polyline;

      if (obj == null)
        throw new System.Exception("Failed to get alignment as polyline");

      var pline2d = obj.ConvertTo(false);
      obj.Erase();

      AddCurveEntityToDrawing(doc, trans, pline2d, AfaAlignmentCadLayer);

      return pline2d;
    }

    /// <summary>
    /// Adds the given curve entity to the database of the drawing.
    /// </summary>
    /// <param name="doc"></param>
    /// <param name="trans"></param>
    /// <param name="curve"></param>
    /// <param name="layerId"></param>
    private static void AddCurveEntityToDrawing(Document doc, Transaction trans, Curve curve, ObjectId layerId)
    {
      if (doc == null || curve == null || layerId.IsNull)
        throw new System.Exception("Parameters invalid");

      var blockTable = trans.GetObject(doc.Database.BlockTableId, OpenMode.ForRead) as BlockTable;
      if (blockTable == null)
        return;

      var blockTableRecord = trans.GetObject(blockTable[BlockTableRecord.ModelSpace], OpenMode.ForWrite) as BlockTableRecord;
      if (blockTableRecord == null)
        return;

      curve.SetLayerId(layerId, false);
      blockTableRecord.AppendEntity(curve);
      trans.AddNewlyCreatedDBObject(curve, true);
    }

    /// <summary>
    /// Sets the m-value of each vertex of the given curve entity to the respective station value on the alignment.
    /// An optional mfactor variable can be passed to apply a conversion factor to the station value.
    /// This can be useful if the m-values are to be stored in different units than the AutoCAD stationing.
    /// </summary>
    /// <param name="alignment"></param>
    /// <param name="curve"></param>
    /// <param name="trans"></param>
    /// <param name="doc"></param>
    /// <param name="mFactor"></param>
    private static void SetMValuesFromStations(Alignment alignment, Curve curve, Transaction trans, Document doc, double mFactor = 1)
    {

      if (doc == null || curve == null || alignment == null)
        throw new System.Exception("Parameters invalid");

      // only polyline2d and polyline3d support m-values
      if (!(curve is Polyline2d || curve is Polyline3d))
        throw new System.Exception("Parameters invalid");

      // Can get the vertices of the polyline from the ArcGIS For AutoCAD M-Values API
      var vertices = AFA.Feature.MValues(doc, curve.ObjectId)?.Keys;

      if (vertices == null || !vertices.Any())
        return;

      // Iterate each vertex.
      // find the station value for the alignment at the vertex position.
      // Set the vertex m-value to the station value.
      foreach (ObjectId vertexOid in vertices)
      {
        var vertex = trans.GetObject(vertexOid, OpenMode.ForWrite);

        Point3d position;

        if (vertex is Vertex2d v2d)
          position = v2d.Position;
        else if (vertex is PolylineVertex3d v3d)
          position = v3d.Position;
        else
          continue;

        var station = GetStationWithEquations(alignment, position);

        AFA.Feature.MValueSet(doc, vertexOid, station * mFactor);
      }
    }

    /// <summary>
    /// Gets the station of the given point3d on the alignment.
    /// This will throw an exception if the position given is not on the alignment.
    /// </summary>
    /// <param name="alignment"></param>
    /// <param name="position"></param>
    /// <returns></returns>
    private static double GetStationWithEquations(Alignment alignment, Point3d position)
    {
      double rawStation = 0;
      double Offset = 0;
      alignment.StationOffset(position.X, position.Y, ref rawStation, ref Offset);

      if (!alignment.StationEquations.Any())
        return rawStation;

      // since station equations may exist, get the station string then clean and parse it.
      var adjustedStationString = alignment.GetStationStringWithEquations(rawStation);

      // station strings typically contain characters such as "+"
      // see https://help.autodesk.com/view/CIV3D/2025/ENU/?guid=GUID-C2CAF36B-0593-45DA-A8FA-F4C587D794EE
      // use a regex to remove all but digit and decimal separators.
      // Adjust this logic as necessary for edge cases such as station strings that use "-" and also contain negative stations
      adjustedStationString = Regex.Replace(adjustedStationString, @"[^0-9\.,-]", "");

      // parsing may fail if the station string does not conform to the current thread culture parsing rules!
      double parsedStation = 0;
      double.TryParse(adjustedStationString, out parsedStation);

      return parsedStation;
    }

    private const string AfaAlignmentCadLayerName = "AfaAlignments";
    private static ObjectId AfaAlignmentCadLayer;

    /// <summary>
    /// Creates a CAD layer onto which the generated features will be drawn.
    /// </summary>
    /// <param name="doc"></param>
    private static void CreateCadLayerForAlignmentFeatures(Document doc)
    {

      if (doc == null)
        throw new System.Exception("Parameters invalid");

      using (var trans = doc.TransactionManager.StartTransaction())
      {
        var layerTable = trans.GetObject(doc.Database.LayerTableId, OpenMode.ForWrite) as LayerTable;

        if (layerTable == null)
          return;

        if (layerTable.Has(AfaAlignmentCadLayerName))
        {
          AfaAlignmentCadLayer = layerTable[AfaAlignmentCadLayerName];
        }
        else
        {
          using (LayerTableRecord tableRecord = new LayerTableRecord())
          {
            tableRecord.Color = Color.FromColorIndex(ColorMethod.ByAci, 3);
            tableRecord.Name = AfaAlignmentCadLayerName;
            var recordOid = layerTable.Add(tableRecord);
            trans.AddNewlyCreatedDBObject(tableRecord, true);
            AfaAlignmentCadLayer = recordOid;
          }
        }

        trans.Commit();
      }
    }

    /// <summary>
    /// Creates a document feature layer to track the generated GIS features.
    /// </summary>
    /// <param name="doc"></param>
    private static void CreateFeatureLayer(Document doc)
    {
      if (doc == null)
        throw new System.Exception("Parameters invalid");

      if (!AFA.FeatureLayer.Names(doc).Any(x => x == "AfaAlignments"))
        AFA.DocFeatureLayer.Add(doc, "AfaAlignments", "Polyline", new List<string> { AfaAlignmentCadLayerName });
    }
  }
}