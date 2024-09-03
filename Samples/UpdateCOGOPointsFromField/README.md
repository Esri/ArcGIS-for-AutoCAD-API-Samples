# Use Update COGO Points from Field (Civil 3D Sample)

This sample AutoLISP command function updates COGO point descriptions based on an ArcGIS for AutoCAD attribute field. 

![Cover_](https://media.devtopia.esri.com/user/7561/files/e93f3d3f-f847-4947-b113-cd9138b5469d)

## Use case

This sample AutoLISP command function updates COGO point descriptions for trees in Redlands, California.

## How it works

The user designates the ArcGIS for AutoCAD point feature layer containing COGO points to operate within and the name of the ArcGIS for AutoCAD attribute field containing the new COGO point descriptions. For every COGO point in the ArcGIS for AutoCAD point feature layer, its designated attribute value is gathered, and the [esri_feature_changeElementType](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-feature-changeelementtype.htm) API sets the COGO point description to the attribute value.  
    
## Use the sample
1. To prepare, download the [UpdateCOGOPointsFromField.lsp](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/UpdateCOGOPointsFromField/UpdateCOGOPointsFromField.lsp) file from the GitHub folder, and download and open the [UpdateCOGOPoints_Sample.dwg](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/UpdateCOGOPointsFromField/UpdateCOGOPoints_Sample.dwg) file from the GitHub folder. The Civil 3D sample drawing contains an ArcGIS for AutoCAD document feature layer of tree COGO points in Redlands, California, with elevation values and ArcGIS for AutoCAD attributes for tree genera and tree heights (in meters).
2.	View the tree data in ArcGIS for AutoCAD. The points are gathered in a point group with a tree point style and a point label style that displays point numbers and descriptions. The point group property overrides are set to maintain the tree point style and the point label style. 

    ![Before_](https://media.devtopia.esri.com/user/7561/files/9c2e501c-58d7-4a39-a8d6-370a432fce09)

3.	In the **Esri Contents** pane, on the **Trees_Redlands** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. The descriptions are currently set to the tree heights in meters from the **TreeHeightMeters** field. Set the COGO point descriptions to the tree genera from the **TreeGenus** field.
 
    ![NewAttributes_](https://media.devtopia.esri.com/user/7561/files/aec39ec6-f17f-4dd7-bd82-e8d49be467a5)

4.	Load the LSP file from your computer and then type "updateCOGOPointsFromField" in the command line to access the custom tool.

    ![CommandLine_](https://media.devtopia.esri.com/user/7561/files/559741cb-6a64-4d13-adf0-3888a2be9e23)

5.	Type the ArcGIS for AutoCAD feature layer, "Trees_Redlands".
6.	Type the attribute field with the new COGO point descriptions, "TreeGenus".
7.	The descriptions are successfully updated to show the genus of the each tree. 

    ![After_](https://media.devtopia.esri.com/user/7561/files/2207af05-9443-470c-af67-a52c231564f0)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/411d2330-c474-4784-9d1d-369e4c8e58ad

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample UpdateCOGOPointsFromField.lsp
``` LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; UPDATE COGO POINT DESCRIPTIONS BASED ON AN ARCGIS FOR AUTOCAD ATTRIBUTE FIELD
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:updateCOGOPointsFromField ()
  
  ; Get the target feature layer and attribute field for COGO point descriptions, and select the feature layer
  (setq flName (getstring "Enter the Feature Layer name : "))
  (setq attName (getstring "Enter the attribute field name for COGO point descriptions : "))
  (setq flSelection (esri_featurelayer_select flName))
  (setq flLength (sslength (esri_featurelayer_select flName)))
  
  ; Loop through every COGO point and gather its attribute field value 
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
    
    ; Set the COGO point description to the retrieved attribute value
    (esri_feature_changeElementType ss
      (list 
        (cons "Type" "AECC_COGO_POINT") 
        (cons "Description" attValue)
      )
    )
    (setq ss nil)
    (setq entCount (+ 1 entCount))
  )
)
``` 
## Relevant API

_The **updateCOGOPointsFromField** sample command uses the following ArcGIS for AutoCAD Lisp API functions:_

- [esri_feature_changeElementType](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-feature-changeelementtype.htm) – The function changes the element type of a selection set of point features.
  
- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.
  
- [esri_attributes_get](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) – This function gets an associated list of the field names and their attribute values.
