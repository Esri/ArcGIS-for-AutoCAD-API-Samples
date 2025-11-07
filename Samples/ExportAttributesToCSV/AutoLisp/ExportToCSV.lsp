;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; This sample routine exports a feature layer's attributes to a CSV file.
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:exportToCSV ()
  
  ; Choose the feature layer and the file location for the new CSV. Present user with file picker window. 
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq csvPath (getfiled "Create a CSV" (strcat featureLayer "_export") "csv" 1))
  
  ; Create a new CSV file and open it for write
  (if (setq csvFile (open csvPath "w")) 
      (progn     
        
        ;; Get and format the attribute field name of the entire feature layer. Write to CSV as the header info. 
        (setq fieldNameList (esri_fielddef_names featureLayer))
        (setq attString "")
        (foreach fieldName fieldNameList
          (setq attString (strcat attString fieldName ","))
        )
        (setq lineLength (strlen attString))
        (setq attString (substr attString 1 (1- lineLength)))
        (write-line attString csvFile)

        
        ;; Get and format the attribute values of the entire feature layer.
        (setq rawFieldResults (esri_featurelayer_getattributes featureLayer))
        (setq numberOfFeatures (length rawFieldResults))
        (if (< 500 numberOfFeatures) (alert "This may take a while"))
        (setq featureEntry "")
        ;; loop through every attribute value
        (foreach entry rawFieldResults
          (setq attFieldPair entry)
          ;; convert each field value as needed to a string          
          (foreach fieldValue attFieldPair
            (setq fieldValue (cdr fieldValue))
            (if (= 'INT (type fieldValue))
              (setq fieldValue (itoa fieldValue))
            )
            (if (= 'REAL (type fieldValue))
              (setq fieldValue (rtos fieldValue 2 2))
            )
            (if (= nil (type fieldValue))
              (setq fieldValue "")
            )
            ;; add commas between each attribute value as required by a CSV
            (setq featureEntry (strcat featureEntry fieldValue ","))
          )
          (setq lineLength (strlen featureEntry))
          ;; remove any trailing commas and write the attribute value to the CSV
          (setq featureEntry (substr featureEntry 1 (1- lineLength)))
          (write-line featureEntry csvFile)
          (setq featureEntry "")
        )

        ; Close the file and show export completion
        (close csvFile)
        (alert (strcat "export complete: " csvPath))
      )
      (princ "\nUnable to create/modify file.")
    )
)
