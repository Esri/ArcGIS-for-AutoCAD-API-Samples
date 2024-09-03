# Use Rotate Blocks From Field (Sample)
This sample AutoLISP command function rotates the angles of blocks based on an ArcGIS for AutoCAD attribute field.

![Cover_](https://media.devtopia.esri.com/user/7561/files/c70d831f-8a21-4ceb-b01d-5dc1e13f6e84)

## Use case
This sample AutoLISP command function rotates blocks of electric transformers in Penticton, Canada. 

## How it works
The user designates the ArcGIS for AutoCAD feature layer of block features to operate within and the name of the ArcGIS for AutoCAD attribute field that contains the rotation values as function parameters. For every block feature in the ArcGIS for AutoCAD feature layer, its rotation value is gathered, then the degree of rotation is applied to the block. The calculation runs whether the user inputs a float, integer, or string attribute field.

## Use the sample
1. To prepare, download the [RotateBlocks.lsp](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/RotateBlocksFromField/RotateBlocks.lsp) file from the GitHub folder, and download and open the [RotateBlocks_Sample.dwg](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/RotateBlocksFromField/RotateBlocks_Sample.dwg) file from the GitHub folder. The AutoCAD sample drawing contains an ArcGIS for AutoCAD point document feature layer of electric transformer locations with an ArcGIS for AutoCAD attribute field of rotation values. The electric transformers are represented by blocks. 
2. View the transformer block data in ArcGIS for AutoCAD. 

    ![Before_](https://media.devtopia.esri.com/user/7561/files/7fe3fabe-2be4-411a-a331-550ba99baeaf)
    
3. In the **Esri Contents** pane, on the **Transformer_Symbol** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. The **Transformer_Symbol** layer contains the **Rot_Value** attribute field, which has the angle to rotate each block.

    ![NewAttributes_](https://media.devtopia.esri.com/user/7561/files/95f79700-9256-441b-9544-abe36aa6902f)
    
4. Load the LSP file from your computer and then type "(rotateBlocks "Transformer_Symbol" "Rot_Value")" in the command line to access the custom tool and apply it to the designated feature layer and rotation attribute field. The two parameters entered must be typed in quotations.

    ![Command_Line_](https://media.devtopia.esri.com/user/7561/files/e3cb6918-2dde-40f6-92c5-d15df88e0e71)

5. The blocks are now rotated according to their rotation angle values.

    ![After_](https://media.devtopia.esri.com/user/7561/files/2cd5c7c9-9dd3-4d28-a7c3-e154a5c5e973)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/ab76614a-8f7f-4520-a29f-117e3fa2441a

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample RotateBlocks.lsp
```LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; FUNCTION TO ROTATE THE ANGLES OF BLOCKS BASED ON AN ARCGIS FOR AUTOCAD ATTRIBUTE FIELD VALUE
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;Description:
;============
;Function rotates the angles of blocks based on an ArcGIS for AutoCAD attribute field value
;
;Inputs:  
;========
;Name of feature layer, name of attribute field with rotation values
;
;Outputs:
;========
;None

(defun rotateBlocks (flName rotAttName)
  
  ; Choose and select the feature layer that contains the blocks with rotation attributes
  (setq flSelection (esri_featurelayer_select flName))
  (setq flLength (sslength (esri_featurelayer_select flName)))
  (setq entCount 0)
  
  ; Loop through each entity in the feature layer
  (repeat flLength 
    (setq ss (ssadd))
    (setq entName (ssname flSelection entCount))
    (ssadd entName ss)
    
    ; Get the entity's rotation attribute value from the rotation field
    (setq rotValue 
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" flName)
          (cons "FIELDNAME" rotAttName)
        )
      )
    )
    (setq rotValue (cdr (nth 0 rotValue)))
    
    ; Set the rotation value to float if the rotation value is text
    (cond
      ((= (type rotValue) 'STR )
        (setq rotValue (atof rotValue))
      )
    )      

    ; Rotate the block with the rotation value
    (setq rotValueRadians (* pi (/ rotValue 180.0)))
    (setq ed (entget entName))
    (entmod (subst (cons 50 rotValueRadians)(assoc 50 ed) ed))
    
    (setq ss nil)
    (setq entCount (+ 1 entCount))
  )
)
```
## Relevant API
_The **rotateBlocks (flName rotAttName)** sample function uses the following ArcGIS for AutoCAD Lisp API functions:_

- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.
      
- [esri_attributes_get](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) – This function gets an associated list of the field names and their attribute values.
