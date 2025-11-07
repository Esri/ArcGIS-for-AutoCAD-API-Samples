# Copy Attributes

This sample copies the ArcGIS for AutoCAD attributes from one entity and adds them to another.

![CoverPic1](../../../Resources/Images/CopyAttributes_1.png)

## Description

This example copies and applies ArcGIS for AutoCAD building attributes from one house to another on housing plans for Catalina Island. The AutoCAD sample drawing contains a document feature layer comprised of polygons for a few new homes on Catalina Island. A document feature layer with roads in the area is included for additional context. 

## Explore the sample

1. Open the [CopyAttributes_Sample.dwg](CopyAttributes_Sample.dwg) drawing and load the dll you built in Visual Studio.

2. Add a new house to our housing plan by drawing a closed polyline on the AutoCAD layer "Houses".

3. To better understand our sample drawing, open the attribute table of the "HousingPlan" layer and review the current properties.  Note that the new house has no values for the properties such as the bedrooms or style.  

     ![AttributeTableBefore_](../../../Resources/Images/CopyAttributes-2.png)

     

4. To copy the attributes from an existing house to the new house, run the ```AFA_Samples_CopyAttributes``` command.

5. Select any of the existing houses as the source entity.

6. Select your new house as the destination entity. 

7. Either open the attribute table or choose **Identify** from the ArcGIS for AutoCAD ribbon to see the attributes on your new house. From here you can update the number of bedrooms or any other additional changes you might want. 

   ![AfterAttributes_](../../../Resources/Images/CopyAttributes-5.png)



## How it works 

1. Prompt for the source entity
2. Use [`Attributes.Get`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/attributesget-net.htm) to read the attributes from the source entity
3. Select the destination entity
4. Apply the attributes retrieved from the source entity to the destination entity with [`Attributes.Set`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/attributesset-net.htm)

## Relevant  API
_The **AFA_Samples_CopyAttributes** sample command uses the following ArcGIS for AutoCAD .NET API methods:_
- [```FeatureLayer.SelectEntity```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/featurelayerselectentity-net.htm) - This method prompts the selection of one entity and returns its AutoCAD ObjectId.

- [```Attributes.Get```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/attributesget-net.htm) – This method gets a dictionary of the field names and their attribute values.

- [```Attributes.Set```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/attributesset-net.htm) – This method adds or modifies feature attributes on an entity of a feature layer.

