using Autodesk.AutoCAD.ApplicationServices;
using Autodesk.AutoCAD.Runtime;
using AFASamples;
using AFA = Esri.ArcGISForAutoCAD;

[assembly: CommandClass(typeof(CopyAttributes))]

namespace AFASamples
{
  class CopyAttributes
  {
    /// <summary>
    /// This sample command copies the attributes from one entity and applies them to another.
    /// </summary>
    [CommandMethod("AFA_Samples_CopyAttributes")]
    public static void CopyAttributesCommand()
    {
      Document doc = Application.DocumentManager.MdiActiveDocument;
      const string featureLayerName = "HousingPlan";

      using (doc.LockDocument())
      {
        try
        {
          // Prompt user for relevant entities
          var sourceObjId = AFA.FeatureLayer.SelectEntity(doc, featureLayerName, null, "\nSelect the source entity: ");
          var destObjId = AFA.FeatureLayer.SelectEntity(doc, featureLayerName, null, "\nSelect the destination entity: ");
          if (sourceObjId.IsNull || destObjId.IsNull) 
            return;

          // Gather attributes from the source entity
          var sourceAttributeDict = AFA.Attributes.Get(doc, sourceObjId, featureLayerName);

          // Assign the attributes to the destination entity
          AFA.Attributes.Set(doc, destObjId, featureLayerName, sourceAttributeDict);
        }
        catch (System.Exception ex)
        {
          doc.Editor.WriteMessage(ex.Message);
        }
      }
    }
  }
}
