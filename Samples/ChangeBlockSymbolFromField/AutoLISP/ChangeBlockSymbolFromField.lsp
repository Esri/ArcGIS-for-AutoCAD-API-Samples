;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; This sample routine updates Autodesk AutoCAD block references based on values from ArcGIS attributes. 
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:AFA_Samples_ChangeBlockSymbolFromField ()

  (progn  
    ; Feature layer name and the attribute field name containing the block definition name
    (setq flName "Doors") 
    (setq attName "DoorType")
    
    ; Select the feature layer
    (setq flSelection (esri_featurelayer_select flName))
    (setq flLength (sslength flSelection))
    (if (> flLength 0)
      (progn
    
        ; Loop through every point and get the block definition name from the attribute field value
        (setq entCount 0)
        (repeat flLength 
          (setq ss (ssadd))
          (setq entName (ssname flSelection entCount))
          (ssadd entName ss)
          (setq symbolName 
            (esri_attributes_get entName 
              (list 
                (cons "FLNAME" flName)
                (cons "FIELDNAME" attName)
              )
            )
          )
          (if symbolName
            (progn
              (setq symbolName (cdr (nth 0 symbolName)))
              
              ; Swap the original point entity to the block reference retrieved from the attribute field value
              (esri_feature_changeElementType ss
                (list 
                  (cons "Type" "Block Reference") 
                  (cons "Description" symbolName)
                )
              )
            )
          )
          (setq ss nil)
          (setq entCount (+ 1 entCount))
        )
      )
      (princ "No features found.")
    )
  )
  (princ)
)
