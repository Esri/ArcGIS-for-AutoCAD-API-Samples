
(defun rotateLabel (flname labelAttName rotAttName)
  ; get the feature layer selection set
  (setq flSelection (esri_featurelayer_select flname))
  ; get the number of features in the selection set
  (setq flLength (sslength (esri_featurelayer_select flname)))
  ; set counter to zero
  (setq entCount 0)
  ;loop through each feature in the feature layer, rotate one 
  (repeat flLength 
    ; create an empty selection set
    (setq ss (ssadd))
    ; get the AutoCAD entity name for the current feature
    (setq entName (ssname flSelection entCount))
    ; add the feature to the selection set
    (ssadd entName ss)
    ; get the attribute value list for the entity
    (setq rotValue 
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" flname)
          (cons "FIELDNAME" rotAttName)
        )
      )
    )
    ;get the entity name of the label associated with the entity
    (setq labelEntName (car (esri_label_get labelAttName entName)))
    ;grab the field value returned attribute list
    (setq rotValue (cdr (nth 0 rotValue)))
    ;convert the value to radians
    (setq rotValueRadians (* pi (/ rotValue 180.0)))
    ;grab the entity data of the label
    (setq ed (entget labelEntName))
    ;modify the entity with the new rotation value from the field
    (entmod (subst (cons 50 rotValueRadians)(assoc 50 ed) ed))
    ; empty the selection set for the next point
    (setq ss nil)
    ; add one to the counter to get to the next point
    (setq entCount (+ 1 entCount))
  )
)