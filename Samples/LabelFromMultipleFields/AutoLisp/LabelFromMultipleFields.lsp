;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; This sample routine concatenates multiple ArcGIS attribute values into one MText entity.
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:AFA_Samples_LabelFromMultipleFields ()
 
  (progn 
    ;; Fields to concatenate
    (setq field1 "STATE_NAME") 
    (setq field2 "POPULATION") 
    (setq field3 "STATE_ABBR") 
    
    (if (or (= field1 "") (= field2 "") (= field3 "")) 
      (princ "\nField names cannot be empty.")
      (progn 

        ;; Loop to label multiple features without restarting command
        (while (setq ent (entsel "\nSelect feature to label: ")) 
          (setq ename (car ent))

          ;; Get all attributes for the feature
          (setq atts (esri_attributes_get ename))
          
          ;; Check for valid list of attributes
          (if (and atts (listp (car atts))) 
            (progn 
              
              ;; Extract values using a helper to be case-insensitive
              (setq val1 (Get-Att-Value atts field1))
              (setq val2 (Get-Att-Value atts field2))
              (setq val3 (Get-Att-Value atts field3))
                  
              (if (and val1 val2 val3) 
                (progn 

                  ;; Collate values with a new line separator (\P for MText)
                  ;; Convert values to strings
                  (setq labelText 
                    (strcat 
                      "\\LState Info\\l\\P"
                      field1 ": " (vl-princ-to-string val1) 
                      "\\P"
                      field2 ": "(vl-princ-to-string val2)
                      "\\P"
                      field3 ": "(vl-princ-to-string val3)
                    )
                  )

                  ;; Prompt for label location and create MText
                  (setq pt (getpoint "\nPick label location: "))
                  (command "._MTEXT" pt "H" 25000 "W" 50 labelText "") ;; Adjust text size
                )
                (princ "\nCould not find one or more fields on this feature.")
              )    
            )
            (princ "\nSelected object is not an ArcGIS feature or has no attributes.")
          )
        )
      )
    )
  )
  (princ)
)
            

;; Helper function to get attribute value case-insensitively
(defun Get-Att-Value (atts fieldName / item val) 
  (setq fieldName (strcase fieldName))
  (foreach item atts 
    (if (and (listp item) (= (strcase (car item)) fieldName)) 
      (setq val (cdr item))
    )
  )
  val
)

