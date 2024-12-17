;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; ; This sample copies the ArcGIS for AutoCAD attributes from one entity and adds them to another
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