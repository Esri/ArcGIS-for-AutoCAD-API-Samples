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