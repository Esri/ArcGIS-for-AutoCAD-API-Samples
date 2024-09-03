;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; CONCATENATE VALUES FROM TWO ARCGIS FOR AUTOCAD ATTRIBUTE FIELDS WITH A DELINEATOR TO FILL A NEW STRING ATTRIBUTE FIELD AND GENERATE LABELS
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:concatenateFieldsToLabel()
  
  ; Get and select the feature layer
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq featureLayerSelection (esri_featurelayer_select featureLayer))
  (setq featureLayerLength (sslength featureLayerSelection))
  
  ; Get the names of the attribute fields to become the first and second parts of the new string field, and a delineator to separate them
  (setq firstField (getstring "Enter the first attribute field name : "))
  (setq secondField (getstring "Enter the second attribute field name : "))
  (setq delineator (getstring T "Enter a delineator to separate the two fields: "))
  
  ; Name and create a new empty string field to hold the newly concatenated values
  (setq newTextField (getstring "Enter the new text field name to be created : "))
  (esri_fielddef_add featureLayer
    (list
      (cons "name" newTextField)
      (cons "Type" "String")
    )
  )

  ; Loop through each entity in the feature layer
  (setq entCount 0)
  (repeat featureLayerLength 
    (setq textFill "") 
    (setq ss (ssadd))
    (setq entName (ssname featureLayerSelection entCount))
    (ssadd entName ss)
    
    ; Get the entity's first attribute field value
    (setq firstAttributes
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" featureLayer)
          (cons "FIELDNAME" firstField)
        )
      )
    ) 
    (setq firstValue (cdr (car firstAttributes)))
 
    ; Convert the first attribute field value to a string, if it is a float or integer 
    (cond
      ((= (type firstValue) 'REAL )
        (setq firstValue (rtos firstValue))
      )
      ((= (type firstValue) 'INT )
        (setq firstValue (itoa firstValue))
      )
    )
    
    ; Get the entity's second attribute field value
    (setq secondAttributes
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" featureLayer)
          (cons "FIELDNAME" secondField)
        )
      )
    ) 
    (setq secondValue (cdr (car secondAttributes)))   
    
    ; Convert the second attribute field value to a string, if it is a float or integer
    (cond
      ((= (type secondValue) 'REAL )
        (setq secondValue (rtos secondValue))
      )
      ((= (type secondValue) 'INT )
        (setq secondValue (itoa secondValue))
      )
    )
    
    ; Concatenate the fields with the delineator, and assign the new text to the new field
    (setq textFill (strcat firstValue delineator secondValue))
    (esri_attributes_set
      entName
      featureLayer
      (list 
        (cons newTextField textFill)
      )
    )
    
    (setq entCount (+ 1 entCount))
  )
  
  ; Generate labels from the new field with the chosen OFFSET and TEXTSIZE
  (esri_label_generate featureLayer newTextField
    (list
      (cons "OFFSET" '(0 0 0))
      (cons "TEXTSIZE" 9)
    )
  )  
)