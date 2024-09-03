# Use Rotate Labels From Field (Sample)

This sample AutoLISP function rotates the angles of labels based on an ArcGIS for AutoCAD attribute field.

![Cover_](https://media.devtopia.esri.com/user/7561/files/a51acb85-539f-4ce3-96b7-20f9b3fd041d)

## Use case 
This sample AutoLISP function rotates asset ID labels on water junctions in Naperville, Illinois.

## How it works 

The user designates the ArcGIS for AutoCAD feature layer to operate within, and the names of the ArcGIS for AutoCAD attribute fields that contain the label names and rotation values as function parameters. For every feature in the ArcGIS for AutoCAD feature layer, its label name and rotation value are gathered, then the degree of rotation is applied to the label. The calculation runs whether the user inputs a float, integer, or string attribute field.

## Use the sample 
1.    To prepare, download the [RotateLabels.lsp](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/RotateLabelsFromField/RotateLabels.lsp) file from the GitHub folder, and download and open the [RotateLabels_Sample.dwg](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/RotateLabelsFromField/RotateLabels_Sample.dwg) file from the GitHub folder. The AutoCAD sample drawing contains an ArcGIS for AutoCAD document feature layer of a subset of water junction point data in Naperville, Illinois. The labels on the water junction data were generated from the **assetid** ArcGIS for AutoCAD attribute field using [esri_generatelabel](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-generatelabel-esri-generate-label.htm). A water network line document feature layer is included for additional context. 
2.	View the water infrastructure data and **assetid** labels in the ArcGIS for AutoCAD tab. 
      
      ![Before_](https://media.devtopia.esri.com/user/7561/files/feb6c794-877c-4fee-81a6-3518deed2a49)

3.	In the **Esri Contents** pane, on the **Water_Junction** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. The **Water_Junction** layer contains the **symbolrotation** attribute field, which has the angle to rotate each label. Rotate the labels to improve legibility.  
      
      ![Attributes](https://media.devtopia.esri.com/user/7561/files/b40c63ba-6ebd-4da1-b6a3-71f5dc71af7f)
      
4.	Load the LSP file from your computer and then type "(rotateLabels “Water_Junction” “assetid” “symbolrotation”)" in the command line to access the custom tool and apply it to the designated feature layer, label attribute field, and rotation attribute field. The three parameters entered must be typed in quotations. 

      ![CommandLine_](https://media.devtopia.esri.com/user/7561/files/cab208bf-ba1d-46d4-a0d3-b7c0cf8f1689)

5.	The labels are now rotated according to their rotation values.

      ![After_](https://media.devtopia.esri.com/user/7561/files/f075d082-1a94-4999-97dc-0803008c51dc)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/c9f9cfce-8f13-4ab6-b864-7c3f28aa2177

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample RotateLabels.lsp
``` LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; FUNCTION TO ROTATE THE ANGLES OF LABELS BASED ON AN ARCGIS FOR AUTOCAD ATTRIBUTE FIELD VALUE
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;Description:
;============
;Function rotates the angles of labels based on an ArcGIS for AutoCAD attribute field value
;
;Inputs:  
;========
;Name of feature layer, name of attribute field with label values, name of attribute field with rotation values
;
;Outputs:
;========
;None

(defun rotateLabels (flName labelAttName rotAttName)
  
  ; Choose and select the feature layer that contains the label and rotation attribute fields
  (setq flSelection (esri_featurelayer_select flName))
  (setq flLength (sslength (esri_featurelayer_select flName)))

  ; Loop through each entity in the feature layer
  (setq entCount 0)
  (repeat flLength 
    (setq ss (ssadd))
    (setq entName (ssname flSelection entCount))
    (ssadd entName ss)
    
    ; Get the entity's rotation attribute value from the rotation attribute field and the entity's label from the label attribute field
    (setq rotValue 
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" flName)
          (cons "FIELDNAME" rotAttName)
        )
      )
    )
    (setq rotValue (cdr (nth 0 rotValue)))
    (setq labelEntName (car (esri_label_get labelAttName entName)))
    
    ; Set the rotation value to float if the rotation value is text
    (cond
      ((= (type rotValue) 'STR )
        (setq rotValue (atof rotValue))
      )
    )   

    ; Rotate the label with the rotation value
    (setq rotValueRadians (* pi (/ rotValue 180.0)))
    (setq ed (entget labelEntName))
    (entmod (subst (cons 50 rotValueRadians)(assoc 50 ed) ed))
    
    (setq ss nil)
    (setq entCount (+ 1 entCount))
  )
)
```

## Relevant API

_The **rotateLabels (flName labelAttName rotAttName)** sample function uses the following ArcGIS for AutoCAD Lisp API functions:_

- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.
      
- [esri_attributes_get](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) – This function gets an associated list of the field names and their attribute values.
      
- [esri_label_get](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-label-get.htm) – This function returns a list containing the entity name of the text entity label linked to a specified feature attribute field of a feature.
