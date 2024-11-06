;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; CALCULATE THE VALUES OF A NEW ARCGIS FOR AUTOCAD ATTRIBUTE FIELD BY APPLYING A MATHEMATICAL EXPRESSION ONTO THE VALUES OF OTHER FIELDS
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:calculateNewField ()
  
  ; Get and select the feature layer
  (setq featureLayer (getstring "Enter the Feature Layer name: "))
  (setq featureLayerSelection (esri_featurelayer_select featureLayer))
  (setq featureLayerLength (sslength featureLayerSelection))
  
  ; Gather the desired mathematical operation to apply 
  (initget "Multiply Divide Add Subtract")
  (setq operation (strcase (getkword "Enter an option [Multiply/Divide/Add/Subtract]: ")))
  
  ; Get the names of the two attribute fields to undergo calculation
  (setq firstField (getstring "Enter the first field name: "))
  (setq secondField (getstring "Enter the second field name: "))
  
  ; Name and create a new float attribute field to hold the newly calculated values
  (setq newField (getstring "Enter name for new field to be created: "))
  (esri_fielddef_add featureLayer
    (list
      (cons "name" newField)
      (cons "Type" "Float")
    )
  )
  
  ; Loop through each entity in the feature layer
  (setq entCount 0)
  (repeat featureLayerLength 
    (setq ss (ssadd))
    (setq entName (ssname featureLayerSelection entCount))
    (ssadd entName ss)
    
    ; Get the entity's first attribute field value for calculation
    (setq firstFieldAttributes
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" featureLayer)
          (cons "FIELDNAME" firstField)
        )
      )
    )
    (setq firstFieldValue (cdr (car firstFieldAttributes)))  
    
    ; Convert the value to a float, if it is a string or integer 
    (cond
      ((= (type firstFieldValue) 'STR )
        (setq firstFieldValue (atof firstFieldValue))
      )
      ((= (type firstFieldValue) 'INT )
        (setq firstFieldValue (float firstFieldValue))
      )
    )

    ; Get the entity's second attribute field value for calculation
    (setq secondFieldAttributes
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" featureLayer)
          (cons "FIELDNAME" secondField)
        )
      )
    )    
    (setq secondFieldValue (cdr (car secondFieldAttributes))) 
    
    ; Convert the value to a float, if it is a string or integer      
    (cond
      ((= (type secondFieldValue) 'STR )
        (setq secondFieldValue (atof secondFieldValue))
      )
      ((= (type secondFieldValue) 'INT )
        (setq secondFieldValue (float secondFieldValue))
      )
    )
    
    ; Perform the appropriate operator calculation 
    (if (equal operation "MULTIPLY")
      (setq finalValue (* firstFieldValue secondFieldValue))
      (if (equal  operation "DIVIDE")
        (setq finalValue (/ firstFieldValue secondFieldValue))
        (if (equal operation "ADD")
          (setq finalValue (+ firstFieldValue secondFieldValue))
          (if (equal operation "SUBTRACT")
            (setq finalValue (- firstFieldValue secondFieldValue))
            (princ "Not an option")
          )
        )
      )
    ) 

    ; Assign the calculated value to the new field
    (esri_attributes_set
      entName
      featureLayer
      (list 
        (cons newField finalValue)
      )
    )

    (setq entCount (+ 1 entCount))
  )
)