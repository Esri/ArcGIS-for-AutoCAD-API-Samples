;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; CONVERT VALUES IN ONE ARCGIS FOR AUTOCAD ATTRIBUTE FIELD TO A DIFFERENT UNIT IN A NEW ATTRIBUTE FIELD USING A CONVERSION RATE
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:unitConversion ()
  
  ; Get and select the feature layer
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq featureLayerSelection (esri_featurelayer_select featureLayer))
  (setq featureLayerLength (sslength featureLayerSelection))
  
  ; Get the name of the attribute field containing the original values and the conversion rate for the new units
  (setq originField (getstring "Enter the origin field name : "))
  (setq multiplier (atof(getstring "Enter the constant to multiply by/the conversion rate : ")))
  
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
    
    ; Get the entity's attribute value in the original unit from the original values attribute field, and set the value to a float if it is a string
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
    
    ; Convert the value into the new unit with the conversion rate, and assign the new value to the new field
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