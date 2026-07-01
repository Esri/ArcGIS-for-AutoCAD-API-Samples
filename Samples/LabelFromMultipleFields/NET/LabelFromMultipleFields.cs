using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.Geometry;
using Autodesk.AutoCAD.Runtime;
using AFASamples;
using AFA = Esri.ArcGISForAutoCAD;

[assembly: CommandClass(typeof(LabelFromMultipleFields))]

namespace AFASamples
{
  class LabelFromMultipleFields
  {
    /// <summary>
    /// This sample routine concatenates multiple ArcGIS attribute values into one MText entity. 
    /// </summary>
    [CommandMethod("AFA_Samples_LabelFromMultipleFields")]
    public static void LabelFromMultipleFieldsCommand()
    {
      Document doc = Application.DocumentManager.MdiActiveDocument;
      Database db = doc.Database;
      const string featureLayerName = "USA_States_Generalized";

      // Fields to concatenate
      const string field1 = "STATE_NAME";
      const string field2 = "POPULATION";
      const string field3 = "STATE_ABBR";

      using (doc.LockDocument())
      {
        try
        {
          // Loop to label multiple features without restarting command
          ObjectId objId;
          do 
          {
            objId = AFA.FeatureLayer.SelectEntity(doc, featureLayerName, null, "\nSelect feature to label: ");
            
            // Get all attributes for the feature
            var attributeDictionary = AFA.Attributes.Get(doc, objId, featureLayerName);
  
            // Check if attributes are valid
            if (attributeDictionary != null)
            {
              // Collate values with a new line separator 
              string value1 = attributeDictionary[field1].ToString();
              string value2 = attributeDictionary[field2].ToString();
              string value3 = attributeDictionary[field3].ToString();
              string labelText = field1 + ": " + value1 + "\\P" + field2 + ": " + value2 + "\\P" + field3 + ": " + value3;
  
              // Prompt for label location 
              Point3d insertionPt = doc.Editor.GetPoint("\nPick label location: ").Value;
  
              // Create MText
              using (Transaction trans = db.TransactionManager.StartTransaction())
              {
                BlockTable blockTable = trans.GetObject(db.BlockTableId, OpenMode.ForRead) as BlockTable;
                if (blockTable == null)
                  continue;
                
                BlockTableRecord btr = trans.GetObject(blockTable[BlockTableRecord.ModelSpace], OpenMode.ForWrite) as BlockTableRecord;
                if (btr == null)
                  continue;
  
                // Create a multiline text object
                // Adjust text size
                using (MText mText = new MText())
                {
                  mText.Location = insertionPt;
                  mText.Width = 50;
                  mText.TextHeight = 25000;
                  mText.Contents = labelText;
  
                  btr.AppendEntity(mText);
                  trans.AddNewlyCreatedDBObject(mText, true);
                }
                trans.Commit();
              }
            }
          } while (objId != ObjectId.Null);
        }
        catch (System.Exception ex)
        {
          doc.Editor.WriteMessage(ex.Message);
        }
      }
    }
  }
}
