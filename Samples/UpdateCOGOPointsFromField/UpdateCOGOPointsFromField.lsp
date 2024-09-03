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