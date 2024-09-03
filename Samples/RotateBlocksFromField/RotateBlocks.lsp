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