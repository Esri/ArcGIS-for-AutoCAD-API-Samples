;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO APPLY DIFFERENT BLOCK SYMBOLS TO POINTS OR BLOCK REFERENCES BASED ON AN ARCGIS FOR AUTOCAD ATTRIBUTE FIELD 
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:changeBlockSymbolFromField ()
  
  ; Get the target feature layer and the attribute field name for block symbols, and select the feature layer
  (setq flName (getstring "Enter the Feature Layer name : "))
  (setq attName (getstring "Enter the attribute field name for block symbols : "))
  (setq flSelection (esri_featurelayer_select flName))
  (setq flLength (sslength (esri_featurelayer_select flName)))
  
  ; Loop through every point and get its block symbol name from the attribute field value
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
    
    ; Set the block reference to the block symbol retrieved from the attribute field value
    (esri_feature_changeElementType ss
      (list 
        (cons "Type" "Block Reference") 
        (cons "Description" attValue)
      )
    )
    (setq ss nil)
    (setq entCount (+ 1 entCount))
  )
)