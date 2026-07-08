using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.EditorInput;
using Autodesk.AutoCAD.Runtime;
using AFASamples;
using AFA = Esri.ArcGISForAutoCAD;

[assembly: CommandClass(typeof(ChangeBlockSymbolFromField))]

namespace AFASamples
{
  class ChangeBlockSymbolFromField
  {
    /// <summary>
    /// This sample routine sets the element type to block reference and assigns block symbols based on values in an attribute field.
    /// </summary>
    [CommandMethod("AFA_Samples_ChangeBlockSymbolFromField")]
    public static void ChangeBlockSymbolFromFieldCommand()
    {
      Document doc = Application.DocumentManager.MdiActiveDocument;
      const string featureLayerName = "Doors";
      const string fieldName = "DoorType";

      using (doc.LockDocument())
      {
        try
        {
          // Get the selection set of features
          var featureSelectionSet = AFA.FeatureLayer.Select(doc, featureLayerName);
          if (featureSelectionSet == null)
            return;

          // For each feature, get the attribute value
          foreach (var objId in featureSelectionSet.GetObjectIds())
          {
            var attributeDictionary = AFA.Attributes.Get(doc, objId, featureLayerName, fieldName);
            if (attributeDictionary == null || !attributeDictionary.ContainsKey(fieldName))
              continue;

            var blockSymbolName = attributeDictionary[fieldName].ToString();

            // Set the block symbol based on the attribute value
            AFA.Feature.ChangeElementType(doc, SelectionSet.FromObjectIds([objId]), "Block Reference", blockSymbolName);
          }
        }
        catch (System.Exception ex)
        {
          doc.Editor.WriteMessage(ex.Message);
        }
      }
    }
  }
}
