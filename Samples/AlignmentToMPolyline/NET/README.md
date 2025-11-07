# Alignment to M-aware Polyline

This sample shows how to generate a Polyline2d feature with M-Values from an Autodesk Civil3D horizontal alignment. The M-values of the resultant feature capture the alignment's stationing.

## Description
This example creates a polyline2d entity from a Civil3D Alignment then writes the equivalent station value to each polyline vertex as an M-Value.

## Use the sample
1. Open a drawing with Alignments. 

2. Load the AfaSamples dll you built in Visual Studio.

3. Run the `AFA_Samples_AlignmentToMPolyline` command.

4. Inspect the resultant GIS Polyline feature using the Esri Identify command to see the M-values match the alignment stationing.

5. Optionally: Share the resultant feature layer to ArcGIS Online or Enterprise. 
## How it works

1. Creates a polyline2d object from the chosen alignment's geometry.
2. Gets the ObjectIds of the polyline's vertices using [`Feature.MValues`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-feature-mvalues.htm)
3. Set the M-value of each vertex object using [`Feature.SetMValue`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-feature-setmvalue.htm)

## Relevant API

_The **AlignmentToMFeature** sample command uses the following ArcGIS for AutoCAD .NET API methods:_
- [`Feature.MValues`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-feature-mvalues.htm)- This method returns a dictionary where the keys are vertex ObjectIds and the values are M-Values.

- [`Feature.SetMValue`](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-feature-setmvalue.htm) – This method sets the M-Value on a Vertex.

