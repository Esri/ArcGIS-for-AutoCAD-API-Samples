using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.EditorInput;
using Autodesk.AutoCAD.Runtime;
using System.IO;
using AFASamples;
using AFA = Esri.ArcGISForAutoCAD;

[assembly: CommandClass(typeof(ExportToCSV))]

namespace AFASamples
{
  class ExportToCSV
  {
    /// <summary>
    /// This sample command exports an ArcGIS for AutoCAD feature layer's attribute table as a CSV file.
    /// </summary>
    [CommandMethod("AFA_Samples_ExportToCSV")]
    public static void ExportToCSVCommand()
    {
      Document doc = Application.DocumentManager.MdiActiveDocument;
      Editor ed = doc.Editor;
      const string featureLayerName = "Houses";

      using (doc.LockDocument())
      {
        try
        {
          // Create new CSV at selected file location
          var csvPath = ed.GetFileNameForSave(new PromptSaveFileOptions("Create a CSV") { InitialFileName = featureLayerName + "_export.csv" })?.StringResult;
          if (string.IsNullOrEmpty(csvPath))
            return;

          using (StreamWriter csvFile = new StreamWriter(csvPath))
          {
            // Write attribute field names as header
            var fieldNames = AFA.FieldDefinition.Names(doc, featureLayerName);
            var fieldNamesString = string.Join(",", fieldNames);
            csvFile.WriteLine(fieldNamesString);

            // Get collection of all the attributes for all the features 
            var featureAttributeDictionaries = AFA.FeatureLayer.GetAttributes(doc, featureLayerName);
            if (featureAttributeDictionaries == null || !featureAttributeDictionaries.Any())
              return;

            // For each feature, write the attribute values to the csv
            foreach (var attributeDictionary in featureAttributeDictionaries)
            {
              var csvRow = "";
              foreach (var kvp in attributeDictionary)
              {
                csvRow += kvp.Value.ToString() + ",";
              }
              csvRow = csvRow.TrimEnd(',');
              csvFile.WriteLine(csvRow);
            }
          }
          ed.WriteMessage("\nExport complete: " + csvPath);
        }
        catch (System.Exception ex)
        {
          doc.Editor.WriteMessage(ex.Message);
        }
      }
    }
  }
}