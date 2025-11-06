using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.Geometry;
using Autodesk.AutoCAD.Runtime;
using AFASamples;
using AFA = Esri.ArcGISForAutoCAD;

[assembly: CommandClass(typeof(RotateBlocksFromField))]

namespace AFASamples
{
  class RotateBlocksFromField
  {
    /// <summary>
    /// This sample command sets the rotation of blocks based on values in an attribute field.
    /// </summary>
    [CommandMethod("AFA_Samples_RotateBlocksFromField")]
    public static void RotateBlocksFromFieldCommand() 
    {
      Document doc = Application.DocumentManager.MdiActiveDocument;
      Database db = doc.Database;
      const string featureLayerName = "Transformer_Symbol"; 
      const string rotationFieldName = "Rot_Value";

      using (doc.LockDocument())
      {
        // Get the selection set of features
        var featureSelectionSet = AFA.FeatureLayer.Select(doc, featureLayerName);
        if (featureSelectionSet == null)
          return;

        using (var transaction = db.TransactionManager.StartTransaction())
        {
          try
          {
            // For each feature, get the rotation value in radians
            foreach (var objId in featureSelectionSet.GetObjectIds())
            {
              var attributeDictionary = AFA.Attributes.Get(doc, objId, featureLayerName, rotationFieldName);
              if (attributeDictionary == null || !attributeDictionary.ContainsKey(rotationFieldName))
                continue;

              var rotationValueRadians = Convert.ToDouble(attributeDictionary[rotationFieldName]) * Math.PI / 180;

              // Rotate each block with the rotation value
              var blockRef = transaction.GetObject(objId, OpenMode.ForWrite) as BlockReference;
              if (blockRef == null)
                continue;

              blockRef.TransformBy(Matrix3d.Rotation(rotationValueRadians, Vector3d.ZAxis, blockRef.Position));
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