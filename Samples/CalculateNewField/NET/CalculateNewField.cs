using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.Runtime;
using AFASamples;
using AFA = Esri.ArcGISForAutoCAD;

[assembly: CommandClass(typeof(CalculateNewField))]

namespace AFASamples
{
  class CalculateNewField
  {
    /// <summary>
    /// This sample command populates a new field on a document feature layer with values calculated from another field.
    /// </summary>
    [CommandMethod("AFA_Samples_CalculateNewField")]
    public static void CalculateNewFieldCommand()
    {
      Document doc = Application.DocumentManager.MdiActiveDocument;
      const string docFeatureLayerName = "Contour_Lines";
      const string fieldName = "Elevation_Meters";
      const string newFieldName = "Elevation_Feet";
      const double multiplier = 3.28084;

      using (doc.LockDocument())
      {
        try
        {
          // Add a field to the document feature layer 
          AFA.FieldDefinition.Add(doc, docFeatureLayerName, newFieldName, "Double");

          // Get the selection set of features
          var featureSelectionSet = AFA.FeatureLayer.Select(doc, docFeatureLayerName);
          if (featureSelectionSet == null)
            return;

          // For each feature, calculate and set a new field value from an existing one
          foreach (var objId in featureSelectionSet.GetObjectIds())
          {
            var attributeDictionary = AFA.Attributes.Get(doc, objId, docFeatureLayerName, fieldName);
            if (attributeDictionary == null || !attributeDictionary.ContainsKey(fieldName) )
              continue;

            var existingFieldValue = attributeDictionary[fieldName];
            var newFieldValue = Convert.ToDouble(existingFieldValue) * multiplier;
            attributeDictionary[newFieldName] = newFieldValue;
            AFA.Attributes.Set(doc, objId, docFeatureLayerName, attributeDictionary);
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