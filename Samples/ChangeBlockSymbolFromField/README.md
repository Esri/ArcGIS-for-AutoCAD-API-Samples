# Use Change Block Symbol from Field (Sample)

This sample AutoLISP command function applies different block symbols to points or block references based on an ArcGIS for AutoCAD attribute field. 

![Cover_](https://media.devtopia.esri.com/user/7561/files/8cb91c5a-7916-47e9-ab38-4ce427f0a510)

## Use case
This sample AutoLISP command function changes door symbols on an office building in Redlands, California.

## How it works
The user designates the ArcGIS for AutoCAD point feature layer to operate within and the ArcGIS for AutoCAD attribute field containing the names of different blocks that are available in the drawing. For every point in the ArcGIS for AutoCAD feature layer, its designated attribute value is gathered, and the [esri_feature_changeElementType](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-feature-changeelementtype.htm) API sets the block reference to the block symbol from the attribute value.

## Use the sample
1. To prepare, download the [ChangeBlockSymbolFromField.lsp](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/ChangeBlockSymbolFromField/ChangeBlockSymbolFromField.lsp) file from the GitHub folder, and download and open the [ChangeBlockSymbolFromField_Sample.dwg](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/ChangeBlockSymbolFromField/ChangeBlockSymbolFromField_Sample.dwg) file from the GitHub folder. The AutoCAD sample drawing contains an ArcGIS for AutoCAD point document feature layer of door locations. An office building document feature layer is included for additional context. 
2.	View the door placement data in the ArcGIS for AutoCAD tab. The blocks in the drawing can be seen in the **Current Drawing Blocks** panel.

    ![Before_](https://media.devtopia.esri.com/user/7561/files/ef103267-f16c-4052-a89e-1dfdf9624100)

3.	In the **Esri Contents** pane, on the **Doors** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. The ArcGIS for AutoCAD attribute table contains a **DoorType** attribute field of block symbol names (for the door type and direction the door is facing); the blocks in the drawing align with the block symbol names in the **DoorType** attribute field.  Change the block symbols to represent their door types. 

    ![Attributes_](https://media.devtopia.esri.com/user/7561/files/6f08aa74-7565-4bd5-8e98-ba10bcdda823)

4.	Load the LSP file from your computer and then type "changeBlockSymbolFromField" in the command line to access the custom tool.

    ![CommandLine_](https://media.devtopia.esri.com/user/7561/files/20f86898-2a36-4014-9ce3-804445475d9c)

5.	Type the name of the ArcGIS for AutoCAD feature layer, "Doors".
6.	Type the ArcGIS for AutoCAD attribute field name that holds the block symbol names, "DoorType".
7.	The doors are updated with the door blocks. 
    
    ![After_](https://media.devtopia.esri.com/user/7561/files/a9d34898-4397-46cd-a65e-9bce159881f0)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/b2ffbce5-9028-47d6-87c6-88704f9f953e


## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample ChangeBlockSymbolFromField.lsp
``` LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO APPLY DIFFERENT BLOCK SYMBOLS TO POINTS OR BLOCK REFERENCES BASED ON AN ARCGIS FOR AUTOCAD ATTRIBUTE FIELD 
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:changeBlockSymbolFromField ()
  
  ; Get the target feature layer and the attribute field name for block symbols, and select the feature layer
  (setq flName (getstring "Enter the Feature Layer name : "))
  (setq attName (getstring "Enter the attribute field name for block symbols : "))
  (setq flSelection (esri_featurelayer_select flName))
  (setq flLength (sslength (esri_featurelayer_select flName)))
  
  ; Loop through every point and get its block symbol name from the attribute field value
  (setq entCount 0)
  (repeat flLength 
    (setq ss (ssadd))
    (setq entName (ssname flSelection entCount))
    (ssadd entName ss)
    (setq attValue 
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" flName)
          (cons "FIELDNAME" attName)
        )
      )
    )
    (setq attValue (cdr (nth 0 attValue)))
    
    ; Set the block reference to the block symbol retrieved from the attribute field value
    (esri_feature_changeElementType ss
      (list 
        (cons "Type" "Block Reference") 
        (cons "Description" attValue)
      )
    )
    (setq ss nil)
    (setq entCount (+ 1 entCount))
  )
)
```
## Relevant API

_The **changeBlockSymbolFromField** sample command uses the following ArcGIS for AutoCAD Lisp API functions:_

- [esri_feature_changeElementType](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-feature-changeelementtype.htm) – This function changes the element type of a selection set of point features.
  
- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.
  
- [esri_attributes_get](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) – This function gets an associated list of the field names and their attribute values.
