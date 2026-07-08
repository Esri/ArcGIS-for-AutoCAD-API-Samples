;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; FUNCTION TO ROTATE THE ANGLES OF LABELS BASED ON AN ATTRIBUTE FIELD VALUE
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun rotateLabels (flName labelAttName rotAttName)
  
  (progn
    ; Select the feature layer with the label and rotation attribute fields
    (setq flSelection (esri_featurelayer_select flName)) 
    (setq flLength (sslength flSelection))
    (if (> flLength 0)
      (progn
        
        ; Loop through each entity in the feature layer
        (setq entCount 0)
        (repeat flLength 
          (progn
            (setq entName (ssname flSelection entCount))
            
            ; Get the entity's rotation attribute value
            (setq rotValue 
              (esri_attributes_get entName 
                (list 
                  (cons "FLNAME" flName)
                  (cons "FIELDNAME" rotAttName)
                )
              )
            )
            (if rotValue
              (progn
                (setq rotValue (cdr (nth 0 rotValue)))
                
                ; Get the entity's label
                (setq labelEntName (car (esri_label_get labelAttName entName)))
                (if labelEntName
                  (progn
                    ; Set the rotation value to float if it is text
                    (cond
                      ((= (type rotValue) 'STR )
                        (setq rotValue (atof rotValue))
                      )
                    )   

                    ; Rotate the label with the rotation value in radians
                    (setq rotValueRadians (* pi (/ rotValue 180.0)))
                    (setq ed (entget labelEntName))
                    (entmod (subst (cons 50 rotValueRadians)(assoc 50 ed) ed))                        
                  )
                )
              )
            )
            (setq entCount (+ 1 entCount))
          )
        )
      )
      (princ "No features found.")
    )
  )
  (princ)
)
