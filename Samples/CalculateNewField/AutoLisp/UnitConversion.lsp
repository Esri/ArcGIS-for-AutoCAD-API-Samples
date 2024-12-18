;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; This sample creates and populates a new field with values calculated from another field using a conversion factor
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:unitConversion ()
  
  ; Get and select the feature layer
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq featureLayerSelection (esri_featurelayer_select featureLayer))
  (setq featureLayerLength (sslength featureLayerSelection))
  
  ; Get the name of the attribute field containing the original values and the conversion factor for the new units
  (setq originField (getstring "Enter the origin field name : "))
  (setq multiplier (atof(getstring "Enter the conversion factor : ")))
  
  ; Name and create a new float attribute field to hold the newly calculated values
  (setq destField (getstring "Enter name for new field to be created : "))
  (esri_fielddef_add featureLayer
    (list
      (cons "name" destField)
      (cons "Type" "Float")
    )
  )
  
  ; Loop through each entity in the feature layer
  (setq entCount 0)
  (repeat featureLayerLength 
    (setq ss (ssadd))
    (setq entName (ssname featureLayerSelection entCount))
    (ssadd entName ss)
    
    ; Get the value of the source attribute, convert to a float
    (setq fieldAttributeOrigin
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" featureLayer)
          (cons "FIELDNAME" originField)
        )
      )
    )    
    (setq originValue (cdr (car fieldAttributeOrigin)))        
    (cond ((= (type originValue) 'STR) (setq originValue (atof originValue))))
    
    ; Multiple the source attribute by the conversion factor and set it as the new field value. 
    (setq destValue (* multiplier originValue))
    (esri_attributes_set
      entName
      featureLayer
      (list 
        (cons destField destValue)
      )
    )
    
    (setq entCount (+ 1 entCount))
  )
)