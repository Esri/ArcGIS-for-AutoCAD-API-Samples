# Rotate Labels to Field Values

This sample routine rotates labels based on rotation values stored as attributes.

![Cover_](../../../Resources/Images/rotateLabels-1.png)

## Description

This example rotates asset ID labels on water junctions in Naperville, Illinois. The accompanying sample drawing contains a feature layer with labeled water junctions.

## Use the sample 
1.    Open the [RotateLabels_Sample.dwg](RotateLabels_Sample.dwg) file and load the [RotateLabels.lsp](RotateLabels.lsp) file. 

2. To better understand the sample drawing, open the attribute table of the **Water_Junction** document feature layer. The rotation values for the labels are stored in the **symbolrotation** attribute field. The labels on the water junction data were generated from the **assetid** attribute field using the [```esri_generatelabel```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-generatelabel-esri-generate-label.htm) command.

    ![Attributes](../../../Resources/Images/rotateLabels-2.png)

3.	To apply the rotation values to the labels, run the `rotateLabels` function and provide "Water_Junction" as the feature layer name, "assetid" as the label source attribute field, and "symbolrotation" as the rotation attribute field.   

4.	The labels have been rotated according to the values from the **symbolrotation** field. Run the command again to pick up any changes you make to the field values.

      ![After1_Pic_](../../../Resources/Images/rotateLabels-3.png)

## How it works
1. Gets the name of the feature layer, name of the attribute field with label values, and the name of the attribute field with rotation values from the user
2. Uses [```esri_featurelayer_select```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) to get a selection set of all the points on the feature layer
3. Uses [```esri_attributes_get```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) to retrieve the rotation value from the designated field for each entity
4. Uses [```esri_label_get```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-label-get.htm) to retrieve the entity name of the label
5. Sets the rotation value of the label to the rotation value from the field (must first be converted to radians)

## Relevant API

_The **rotateLabels (flName labelAttName rotAttName)** sample function uses the following ArcGIS for AutoCAD Lisp API functions:_

- [```esri_featurelayer_select```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.
      
- [```esri_attributes_get```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) – This function gets an associated list of the field names and their attribute values.
      
- [```esri_label_get```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-label-get.htm) – This function returns a list containing the entity name of the text entity label linked to a specified feature attribute field of a feature.
