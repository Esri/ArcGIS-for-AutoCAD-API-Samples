using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.Geometry;
using Autodesk.AutoCAD.Runtime;
using AFASamples;
using AFA = Esri.ArcGISForAutoCAD;

[assembly: CommandClass(typeof(RotateLabelsFromField))]

namespace AFASamples
{
  class RotateLabelsFromField
  {
    /// <summary>
    /// This sample routine rotates the angles of labels based on values in an attribute field.
    /// </summary>
    [CommandMethod("AFA_Samples_RotateLabelsFromField")]
    public static void RotateLabelsFromFieldCommand()
    {
      Document doc = Application.DocumentManager.MdiActiveDocument;
      Database db = doc.Database;
      const string featureLayerName = "Water_Junction";
      const string rotationFieldName = "symbolrotation";
      const string labelFieldName = "assetid";

      using (doc.LockDocument())
      {
        // Get the selection set of features
        var featureSelectionSet = AFA.FeatureLayer.Select(doc, featureLayerName);
        if (featureSelectionSet == null)
          return;

        using var transaction = db.TransactionManager.StartTransaction();
        {
          try
          {
            // For each feature, get the rotation value in radians
            foreach (var featureObjId in featureSelectionSet.GetObjectIds())
            {
              var attributeDictionary = AFA.Attributes.Get(doc, featureObjId, featureLayerName, rotationFieldName);
              if (attributeDictionary == null || !attributeDictionary.ContainsKey(rotationFieldName))
                continue;

              var rotationValueRadians = Convert.ToDouble(attributeDictionary[rotationFieldName]) * Math.PI / 180;

              // Get the feature's rotation anchor 
              // Note: This assumes the feature is a DBPoint and the label is centered around the point feature 
              var feature = transaction.GetObject(featureObjId, OpenMode.ForRead) as DBPoint;
              if (feature == null)
                continue;
              var rotationPoint = feature.Position;

              // Rotate each label with the rotation value
              var labelObjId = AFA.FeatureLabel.Get(doc, labelFieldName, featureObjId);
              if (labelObjId.IsNull)
                continue;

              var label = transaction.GetObject(labelObjId, OpenMode.ForWrite) as DBText; 
              if (label == null)
                continue;

              label.TransformBy(Matrix3d.Rotation(rotationValueRadians, Vector3d.ZAxis, rotationPoint));
            }
          }
          catch (System.Exception ex)
          {
            doc.Editor.WriteMessage(ex.Message);
          }
          finally
          {
            transaction.Commit();
          }
        }
      }
    }
  }
}
