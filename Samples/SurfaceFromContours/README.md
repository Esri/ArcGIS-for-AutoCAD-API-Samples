# Use Surface From Contours (Civil 3D Sample)
This sample AutoLISP command function creates a surface in Civil 3D from an ArcGIS for AutoCAD contour line document feature layer with an elevation (m) ArcGIS for AutoCAD attribute field.

![Cover_](https://media.devtopia.esri.com/user/7561/files/ed8472a3-e738-4d86-943b-20f61179bc88)

## Use case
This sample AutoLISP command function creates a surface from contour lines in Acadia National Park, Maine.

## How it works
The user designates the ArcGIS for AutoCAD document feature layer with contour lines, the name of the ArcGIS for AutoCAD attribute field that contains elevation values in meters, and a name for the new surface. The elevation values are assigned as z-values for the contour lines using the [esri_featurelayer_elevatetofield](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-elevatetofield.htm) API. Then, the contour lines from the feature layer are transformed into VLA-Objects and are used to create a surface with functions in the vl-load-com library. Surface settings and contour line settings for surface creation are customizable. 

_Note: The code is partially adapted from [Jeff Mishler](https://forums.autodesk.com/t5/civil-3d-customization/create-surface-by-lisp/m-p/6470452#M12400)._

## Use the sample
1. To prepare, download the [SurfaceFromContours.lsp](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/SurfaceFromContours/SurfaceFromContours.lsp) file from the GitHub folder, and download and open the [SurfaceFromContours_Sample.dwg](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/SurfaceFromContours/SurfaceFromContours_Sample.dwg) file from the GitHub folder. The Civil 3D sample drawing contains an ArcGIS for AutoCAD document feature layer of contour lines with an ArcGIS for AutoCAD attribute field of elevation values in meters. 
2. View the contour line data in ArcGIS for AutoCAD. There are currently no **Surfaces** in the **Toolspace** pane. 

    ![Before_](https://media.devtopia.esri.com/user/7561/files/ff4196dd-17fc-4c2c-b369-7befcbd89ad7)

3. The ArcGIS for AutoCAD **Acadia_ContourLines** document feature layer does not have z-values assigned yet. Select the contour lines and type "LIST" in the command line to see the z-values set to 0.  
    
    ![ZValues_](https://media.devtopia.esri.com/user/7561/files/f629aa9a-74ea-4c80-824c-6c2483a50ff7)

4. In the **Esri Contents** pane, on the **Acadia_ContourLines** document feature layer, click the **Attribute Table** button. The elevation in meters will be assigned to the contour line z-values using the **Elevation_M** attribute values. Create a surface from the **Acadia_ContourLines** document feature layer. 

    ![NewAttributeTable_](https://media.devtopia.esri.com/user/7561/files/177bcd20-6c25-4461-8f63-5951963770c8)

5. Load the LSP file from your computer and then type "createSurfaceFromContours" in the command line to access the custom tool. 
    
    ![CommandLine_](https://media.devtopia.esri.com/user/7561/files/a3bc3a33-1a9a-4143-891b-0b2fa586f66c)

6. Type the ArcGIS for AutoCAD feature layer, "Acadia_ContourLines".
7. Type the ArcGIS for AutoCAD attribute field that contains elevation values in meters, "Elevation_M". 
8. Name the new surface, "SurfAcadia".
9. The surface is created with the settings set in the AutoLISP sample code.
    
    ![After_](https://media.devtopia.esri.com/user/7561/files/61b85d6c-1680-46b2-b872-f10eab0e22ad)
    
10. Hover your mouse over the surface to see the surface name, the surface layer, and the surface style from the AutoLISP sample code, and the elevation derived from the **Elevation_M** ArcGIS for AutoCAD attribute field.
    
    ![Hover_](https://media.devtopia.esri.com/user/7561/files/a208535e-3623-4505-9a88-3ee5eaf417e3)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/d2084994-d951-45d3-86f3-62a19837d6a8

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample SurfaceFromContours.lsp
```LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO CREATE A SURFACE IN CIVIL 3D FROM AN ARCGIS FOR AUTOCAD CONTOUR LINE DOCUMENT FEATURE LAYER WITH AN ARCGIS FOR AUTOCAD ELEVATION (M) ATTRIBUTE FIELD
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(vl-load-com)
(defun c:createSurfaceFromContours ()
  
  ; Prepare Civil 3D information for surface creation
  (setq prepResults (prepareCivil3DInfo))
  (setq surfaces (car prepResults))
  (setq tincreationdata (cadr prepResults))  
  
  ; Choose the feature layer of contour lines, the attribute field that contains the elevation values in meters, and name the new surface
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq elevationField (getstring "Enter the elevation (m) attribute field name : "))
  (setq surfaceName (getstring "Enter name for new surface : ")) 
  
  ; Apply the feature layer's elevation (m) attribute field to the contour line z-coordinates 
  (esri_featurelayer_elevatetofield featureLayer elevationField)

  ; Convert the contour lines into VLA-Objects
  (setq contours(contourObjects))
  
  ; Create a surface with custom settings
  (surfaceCreation)
)

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; FUNCTION TO PREPARE CIVIL 3D INFORMATION FOR SURFACE CREATION
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;Description:
;============
;Gathers Civil 3D information, the surfaces collection, and the tin creation interface object
;
;Inputs:  
;========
;None
;
;Outputs:
;========
;A list of the surfaces collection and tin creation interface object

(defun prepareCivil3DInfo() 
  
  ; Gather Civil 3D information 
  (setq	C3D	(strcat "HKEY_LOCAL_MACHINE\\" (if vlax-user-product-key (vlax-user-product-key)(vlax-product-key)))) 
  (setq C3D (vl-registry-read C3D "Release")) 
  (setq verString  (substr C3D 1 (vl-string-search "." C3D (+ (vl-string-search "." C3D) 1)))) 
  (setq prodString (strcat "AeccXUiLand.AeccApplication." verString)) 
  (setq dataStr (strcat "AeccXLand.AeccTinCreationData." verString)) 
  (setq *acad* (vlax-get-acad-object)) ; 
  (setq C3D (vla-getinterfaceobject *acad* prodString)) 
  (setq C3Ddoc (vla-get-activedocument C3D)) 
  
  ; Gather the surfaces collection and tin creation interface object from the drawing 
  (setq surfaces (vlax-get C3Ddoc 'surfaces)) 
  (setq tinCreationData (vla-getinterfaceobject *acad* dataStr)) 
  
  ; Return the surfaces collection and tin creation interface object
  (list surfaces tinCreationData) 
)

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; FUNCTION TO CONVERT CONTOUR LINES INTO VLA-OBJECTS
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;Description:
;============
;Loops through each entity in the selected feature layer and converts the contour lines into VLA-Objects
;
;Inputs:  
;========
;None
;
;Outputs:
;========
;Contour lines as VLA-Objects

(defun contourObjects()
  
  ; Select the feature layer
  (setq flSelection (esri_featurelayer_select featureLayer ""))
  (setq flLength (sslength flSelection))
  
  ; Loop through each entity and transform each contour line into a VLA-Object
  (setq entCount 0)
  (setq contours nil)
  (repeat flLength 
    (setq ss (ssadd))
    (setq entName (ssname flSelection entCount))
    (ssadd entName ss)
    (setq contours (cons (vlax-ename->vla-object entName) contours))
    (setq entCount (+ 1 entCount))
  )
  ; Return the contour lines as VLA-Objects 
  contours
)

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; FUNCTION TO CREATE THE SURFACE AND ADD THE CONTOUR LINES WITH CUSTOM SETTINGS
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;Description:
;============
;Assigns custom settings for surface creation and adding contour lines
;Creates the surface and adds the contour lines
;
;Inputs:  
;========
;None
;
;Outputs:
;========
;None

(defun surfaceCreation()
  
  ; Set custom surface settings
  (setq tinBaseLayer "Sample_BaseLayer") ; Base layer for surface
  (setq tinLayer "Sample_BaseLayer") ; Layer for surface
  (setq tinDescription "Created surface from ArcGIS for AutoCAD contour line document feature layer") ; Surface description
  (setq tinStyle "Contours and Triangles") ; Surface style
  
  ; Create surface with the custom settings
  (vlax-put tinCreationData 'baselayer tinBaseLayer) 
  (vlax-put tinCreationData 'layer tinLayer) 
  (vlax-put	tinCreationData 'description tinDescription) 
  (vlax-put tinCreationData 'name surfaceName) ; User-provided surface name
  (vlax-put tinCreationData 'style tinStyle) 
  (setq surf1 (vlax-invoke-method surfaces 'addtinsurface tinCreationData))
  
  ; Set custom settings for the contours
  (setq contourDescription "Contour Lines from ArcGIS for AutoCAD contour line document feature layer") ; Contour description
  (setq weedingDistMeters 15.0) ; Weeding distance (m), default value
  (setq weedingAngleDegrees 4.0) ; Weeding angle (degrees), default value
  (setq supplementalDistanceMeters 100.0) ; Supplemental distance (m), default value
  (setq midOrdinateDistanceMeters 1) ; Mid-ordinate distance (m), default value
  
  ; Add contours to the new surface with the custom settings
  (vlax-invoke (vlax-get surf1 'contours) 'add contours 
    contourDescription 
    weedingDistMeters 
    weedingAngleDegrees 
    supplementalDistanceMeters 
    midOrdinateDistanceMeters 
  )
)
```
## Relevant API 
_The **createSurfaceFromContours** sample command uses the following ArcGIS for AutoCAD Lisp API functions:_
- [esri_featurelayer_elevatetofield](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-elevatetofield.htm) – This function modifies the z-coordinates of the entities of the specified feature layer and any TEXT entities linked to those features.
- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.

## List of Functions 
_The **createSurfaceFromContours** sample command uses the following functions:_
- prepareCivil3DInfo() – This function prepares the necessary data for surface creation by gathering Civil 3D information, the surfaces collection, and the tin creation interface object.
- contourObjects() – This function converts the contour lines into VLA-Objects.
- surfaceCreation() – This function creates the surface and adds the contour lines with custom settings.
