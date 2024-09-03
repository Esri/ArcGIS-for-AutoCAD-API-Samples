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