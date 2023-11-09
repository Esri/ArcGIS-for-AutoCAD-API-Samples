(defun c:testDescriptionFromField ()
  ; Ask for feature layer
  (setq flname (getstring "Name of feature layer? : "))
  ; ask for GIS field
  (setq attname (getstring "Name of field? : "))
  ; get the feature layer selection set
  (setq flSelection (esri_featurelayer_select flname))
  ; get the number of features in the selection set
  (setq flLength (sslength (esri_featurelayer_select flname)))
  ; set counter to zero
  (setq entCount 0)
  ;loop through each feature in the feature layer
  (repeat flLength 
    ; create an empty selection set
    (setq ss (ssadd))
    ; get the AutoCAD entity name for the current feature
    (setq entName (ssname flSelection entCount))
    ; add the feature to the selection set
    (ssadd entName ss)
    ; get the attriubte value list for the point
    (setq attValue 
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" flname)
          (cons "FIELDNAME" attname)
        )
      )
    )
    ; grab the field value from the above list
    (setq attValue (cdr (nth 0 attValue)))
    ; Set the descritption of the point to the field value
    (esri_feature_changeElementType ss
      (list 
        (cons "Type" "AECC_COGO_POINT") 
        (cons "Description" attValue)
      )
    )
    ; empty the selection set for the next point
    (setq ss nil)
    ; add one to the counter to get to the next point
    (setq entCount (+ 1 entCount))
  )
)