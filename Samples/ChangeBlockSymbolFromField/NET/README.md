# Change Block Symbol from Field

This sample routine applies different block symbols to points or block references based on an attribute field. 

![Cover_](../../../Resources/Images/changeBlocks-1.png)

## Description
This example changes door symbols on a commercial building in Redlands, California. Using the ArcGIS for AutoCAD API, block references are set to block symbols based on attribute values. The accompanying sample drawing includes a document feature layer of exterior door locations on a building in Redlands. 

## Use the sample
1. Open the [ChangeBlockSymbolFromField_Sample.dwg](ChangeBlockSymbolFromField_Sample.dwg) file and load the dll you built in Visual Studio.
2.	To better understand the sample drawing, explore the attribute table of the **Doors** feature layer and the current drawing blocks. The attribute table contains a **DoorType** attribute field of block symbol names. 

    ![Attributes_](../../../Resources/Images/changeBlocks-2.png)

3.	To change the block symbols to represent their door types, run the ```AFA_Samples_ChangeBlockSymbolFromField``` command. 

4.	The doors are updated with the door blocks. 
    
    ![After_Pic](../../../Resources/Images/changeBlocks-3.png)

## How it works
1. Gets the name of the feature layer and the field from the user
2. Uses [```FeatureLayer.Select```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/featurelayerselect-net.htm) to create a selection set of each entity in the feature layer 
3. Uses [```Attributes.Get```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/attributesget-net.htm) to read the **DoorType** field value from every point
4. Sets the **DoorType** attribute value as the block reference using [```Feature.ChangeElementType```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/featurechangeelementtype-net.htm)

## Relevant API

_The **AFA_Samples_ChangeBlockSymbolFromField** sample command uses the following ArcGIS for AutoCAD .NET API methods:_

- [```FeatureLayer.Select```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/featurelayerselect-net.htm) – This method returns an AutoCAD selection set filtered by the specified feature layer.

- [```Attributes.Get```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/attributesget-net.htm) – This method gets a dictionary of the field names and their attribute values.

- [```Feature.ChangeElementType```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/featurechangeelementtype-net.htm) – This method changes the element type of a selection set of features.
  
  
