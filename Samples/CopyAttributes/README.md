# Use Copy Attributes (Sample)

This sample AutoLISP command function copies the ArcGIS for AutoCAD attributes from one entity and applies them to another.

![Cover_](https://media.devtopia.esri.com/user/7561/files/1b23ba70-b04c-495f-b031-f75cee7febdb)

## Use case

This sample AutoLISP command function copies and applies ArcGIS for AutoCAD building attributes from one house to another on housing plans for Catalina Island.

## How it works 
   
The user designates the ArcGIS for AutoCAD feature layer to operate within. The user clicks an entity with the ArcGIS for AutoCAD attributes to be copied, and its attributes are recorded. Then, the user clicks another entity that will obtain the recorded attributes, and the attributes are applied.

## Use the sample

1. To prepare, download the [CopyAttributes.lsp](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/CopyAttributes/CopyAttributes.lsp) file from the GitHub folder, and download and open the [CopyAttributes_Sample.dwg](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/CopyAttributes/CopyAttributes_Sample.dwg) file from the GitHub folder. The AutoCAD sample drawing contains an ArcGIS for AutoCAD document feature layer of polygons for a few new homes on Catalina Island. A roads document feature layer is included for additional context. 
2.	View the housing plan data in ArcGIS for AutoCAD.

      ![Before_](https://media.devtopia.esri.com/user/7561/files/101c048b-104b-44f7-9c91-2798abbf8287)

3.	In the **Esri Contents** pane, on the **HousingPlan** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. Change the Mediterranean house ArcGIS for AutoCAD attributes to match the attributes of the other houses.

      ![AttributeTableBefore_](https://media.devtopia.esri.com/user/7561/files/3f93d7a9-e528-45ca-a558-11f0c03ef2c0)

4.	To view the attributes of only the Mediterranean house, click on the second house from the bottom; then click on the **Identify Features** button in the **Edit** panel.

      ![Identify_](https://media.devtopia.esri.com/user/7561/files/6f6e3570-2b9e-42f4-8c5d-1e6cc991a5ac)

5.	Load the LSP file from your computer and then type "copyAttributes" in the command line to access the custom tool.

      ![CommandLine_](https://media.devtopia.esri.com/user/7561/files/493af5af-6b41-4c3e-9973-da1a0f5f5d88)
   
6.	Type the name of the target ArcGIS for AutoCAD feature layer in which you want to copy and designate attributes. For example, type "HousingPlan".
7.	To select the source entity (the object that you want to copy ArcGIS for AutoCAD attributes from), click the building above the Mediterranean-style house.
8. To select the destination entity (the object that you want to copy the ArcGIS for AutoCAD attributes to), click the Mediterranean-style house. 
9. The ArcGIS for AutoCAD attributes are copied, and now the target building has the same attributes. 

   ![AfterAttributes_](https://media.devtopia.esri.com/user/7561/files/9df67b3c-fc7b-4efd-a7d2-9e5bfed286e9)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/a1ebf79e-47f1-4d33-904c-2c7f058803e1

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample CopyAttributes.lsp
``` LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO COPY THE ARCGIS FOR AUTOCAD ATTRIBUTES FROM ONE ENTITY AND APPLY THEM TO ANOTHER
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:copyAttributes ()
  
  ; Choose the feature layer in which to copy and assign ArcGIS attributes 
  (setq featureLayer (getstring "Enter the Feature Layer name: "))
  
  ; Gather attributes from the source entity
  (setq sourceEntity (car(entsel "Select the source entity: ")))
  (setq sourceAttributes (esri_attributes_get sourceEntity ))
  
  ; Assign the attributes to the destination entity
  (setq destEntity (car(entsel "\n Select the destination entity: ")))
  (esri_attributes_set destEntity featureLayer sourceAttributes)
)
```

## Relevant API

_The **copyAttributes** sample command uses the following ArcGIS for AutoCAD Lisp API functions:_

- [esri_attributes_get](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) – This function gets an associated list of the field names and their attribute value.

- [esri_attributes_set](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attribute-set.htm) – This function adds or modifies feature attributes on an entity of a feature layer.
