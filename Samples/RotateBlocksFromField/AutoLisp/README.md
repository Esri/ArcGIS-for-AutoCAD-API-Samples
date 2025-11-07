# Rotate Blocks to Field Value
This sample routine rotates block inserts to a rotation value stored as an attribute.

![Cover_](../../../Resources/Images/rotateBlocks-1.png)

## Description
This example rotates AutoCAD block inserts that represent electric transformers in Penticton, Canada. ArcGIS for AutoCAD can currently rotate blocks based on field values named "Angle" or "Rotation". However, in this case, the sample uses a field named "Rot_Value" for this purpose. The accompanying sample drawing contains a feature layer with blocks depicting transformer locations.

## Explore the sample
1. Open the [RotateBlocks_Sample.dwg](RotateBlocks_Sample.dwg) and load the [RotateBlocks.lsp](RotateBlocks.lsp) file.

3. To better understand our sample drawing, open the attribute table of the "Transformer_Symbol" layer and review the current properties.  Note the values in the "Rot_Value" field, this is where we will pull the rotation for the blocks from.  

    ![NewAttributes_](../../../Resources/Images/rotateBlocks-3.png)
    
4. To apply the rotation values to the blocks, run the ```rotateBlocks``` command and provide "Transformer_Symbol" as the feature layer name and "Rot_Value" as the field name. 

5. The blocks have now been rotated to the values from the "Rot_Value" field. Run the command again to pick up any changes you make to the field values. 
    
    ![RotatedPic](../../../Resources/Images/RotateBlocks_1.png)

## How it works

1. Get the name of the feature layer and the field to use for rotation from the user

2. Use [```esri_featurelayer_select```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) to get a selection set of all the points on the feature layer

3. Use [```esri_attributes_get```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) to retrieve the rotation value from the selected field for each entity

4. Set the rotation value of the block insert to the rotation value from the field (must first be converted to radians)

## Relevant API
_The **rotateBlocks** sample command uses the following ArcGIS for AutoCAD Lisp API functions:_
- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.
  
- [esri_attributes_get](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) – This function gets an associated list of the field names and their attribute values.
