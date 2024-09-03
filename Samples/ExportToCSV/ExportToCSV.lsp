;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO EXPORT AN ARCGIS FOR AUTOCAD FEATURE LAYER'S ARCGIS FOR AUTOCAD ATTRIBUTE TABLE AS A CSV FILE
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:exportToCSV ()
  
  ; Choose the feature layer and the file location for the new CSV
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq csvPath (getfiled "Create a CSV" (strcat featureLayer "_export") "csv" 1))
  
  ; Write to the new file
  (if (setq csvFile (open csvPath "w")) 
      (progn     
        
        ;; Process the field names and write them into CSV format
        (setq fieldNameList (esri_fielddef_names featureLayer))
        (setq attString "")
        (foreach fieldName fieldNameList
          (setq attString (strcat attString fieldName ","))
        )
        (setq lineLength (strlen attString))
        (setq attString (substr attstring 1 (1- lineLength)))
        (write-line attString csvFile)
        ;; End of field name processing 
        
        ;; Process the field values and write them into CSV format
        (setq rawFieldResults (esri_featurelayer_getattributes featureLayer))
        (setq numberOfFeatures (length rawFieldResults))
        (if (< 500 numberOfFeatures) (alert "This may take a while"))
        (setq featureEntry "")
        (foreach entry rawFieldResults
          (setq attFieldPair entry) 
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
            (setq featureEntry (strcat featureEntry fieldValue ","))
          )
          (setq lineLength (strlen featureEntry))
          (setq featureEntry (substr featureEntry 1 (1- lineLength)))
          (write-line featureEntry csvFile)
          (setq featureEntry "")
        )
        ;; End of field value processing

        ; Close the file and show export completion
        (close csvFile)
        (alert (strcat "export complete: " csvPath))
      )
      (princ "\nUnable to create/modify file.")
    )
)