using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.Runtime;
using Autodesk.Civil.DatabaseServices;
using AFASamples;
using AFA = Esri.ArcGISForAutoCAD;

[assembly: CommandClass(typeof(UpdateCOGOPointsFromField))]

namespace AFASamples
{
  class UpdateCOGOPointsFromField
  {
    /// <summary>
    /// This sample command updates COGO point descriptions based on values in an attribute field.
    /// </summary>
    [CommandMethod("AFA_Samples_UpdateCOGOPointsFromField")]
    public static void UpdateCOGOPointsFromFieldCommand()
    {
      Document doc = Application.DocumentManager.MdiActiveDocument;
      Database db = doc.Database;
      const string featureLayerName = "Trees_Redlands"; 
      const string descriptionFieldName = "TreeGenus";

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
            foreach (var objId in featureSelectionSet.GetObjectIds())
            {
              // Get the attribute value
              var attributeDictionary = AFA.Attributes.Get(doc, objId, featureLayerName, descriptionFieldName);
              if (attributeDictionary == null || !attributeDictionary.ContainsKey(descriptionFieldName)) 
                continue;

              var descriptionValue = attributeDictionary[descriptionFieldName].ToString();

              // Set the COGO point description to the retrieved attribute value
              var cogo = objId.GetObject(OpenMode.ForWrite) as CogoPoint;
              if (cogo == null)
                continue;

              cogo.RawDescription = descriptionValue;
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