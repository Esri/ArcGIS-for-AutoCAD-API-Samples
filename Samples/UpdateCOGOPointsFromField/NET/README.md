# Update COGO Point Descriptions from Field

This sample routine updates Autodesk Civil 3D COGO point descriptions with values from ArcGIS attributes. 

![Cover_](../../../Resources/Images/UpdateCogo-1.png)

## Description

This example updates Civil 3D COGO point descriptions for trees in Redlands, California. Using the ArcGIS for AutoCAD API, it updates the point descriptions of the trees with the name of the tree species type. This sample includes a drawing created with Civil 3D. The drawing includes a document feature layer that includes COGO points located in Redlands, California representing trees.



## Use the sample
1. Open the [UpdateCOGOPoints_Sample.dwg](UpdateCOGOPoints_Sample.dwg) drawing and load the dll you built in Visual Studio.

2. To get familiar with the data, explore the attribute table and the prospector. The points are gathered in a point group with a tree point style and a point label style that displays point numbers and descriptions. The point group property overrides are set to maintain the tree point style and the point label style. 

   ![BeforePic](../../../Resources/Images/UpdateCogo_1.png)

3. To update the COGO point descriptions, run the `AFA_Samples_UpdateCOGOPointsFromField` command. 

   

4. Examine the COGO points to confirm the descriptions now include the tree genus values. 

   ![AfterPic](../../../Resources/Images/UpdateCogo_2.png)


## How it works

1. Use [`FeatureLayer.Select`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/featurelayerselect-net.htm) to get a selection set of all the points on the feature layer
2. Use [`Attributes.Get`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/attributesget-net.htm) to read the "TreeGenus" field value from every point
3. Set the "TreeGenus" attribute value as the COGO point description using [`Feature.ChangeElementType`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/featurechangeelementtype-net.htm)

## Relevant API
_The **AFA_Samples_UpdateCOGOPointsFromField** sample command uses the following ArcGIS for AutoCAD .NET API methods:_
- [`FeatureLayer.Select`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/featurelayerselect-net.htm) – This method returns an AutoCAD selection set filtered by the specified feature layer.
  
- [`Attributes.Get`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/attributesget-net.htm) – This method gets a dictionary of the field names and their attribute values.

- [`Feature.ChangeElementType`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/featurechangeelementtype-net.htm) – The method changes the element type of a selection set of features.
