;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; This sample routine copys Object Data from an object to the existing ArcGIS attribute fields of a feature layer. 
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun C:AFA_Samples_CopyObjectDataToFields (/ eName tableName fieldList record result)
  ; Get Document Feature Layer name
  (setq flName (getstring "Enter the Document Feature Layer name: "))
  ; Get the feature layer selection set
  (setq flSelection (esri_featurelayer_select flName))
  ; Get the number of features in the selection set
  (setq flLength (sslength flSelection))
  ; Set counter to zero
  (setq entCount 0)
  ; Loop through each feature of the feature layer 
  (repeat flLength 
    ; Get the AutoCAD entity name for the current feature
    (setq eName (ssname flSelection entCount))
	
    (if eName
      (progn
        ; Get the list of tables attached to this object
        (setq tableList (ade_odgettables eName))
        
        (if tableList
          (foreach tableName tableList
            (setq result nil)
            ; Get the field names for this specific table
            (setq fieldList (ade_odtabledefn tableName))
            
            ; Iterate through field definitions to get values
            ; The field definition returns a list of lists; we need the field name (index 0)
            (setq record 0)
            (foreach field (cdr (assoc "Columns" fieldList))
              (setq fName (cdr (assoc "ColName" field)))
              (setq fValue (ade_odgetfield eName tableName fName record))
              
              ; Build the association list
              (setq result (cons (cons fName fValue) result))
            )
            
            ; Print the resulting list for this table to the command line
            (princ (strcat "\nTable: " tableName "\n"))
            (princ (reverse result))
          )
          (princ "\nNo Object Data tables found on this object.")
        )
      )
      (princ "\nNo object selected.")
    )
	
	(GetODvalue)
    (SetFieldValue)
	
	; add one to the counter to get to the next point
    (setq entCount (+ 1 entCount))
	
  )
  (princ)
);C:CopyODtoFLAttFields

;;;****************************************************************************
;;; Function: GetODvalue
;;;
;;; Get the Object Data values.

(defun GetODvalue ()
   ; Get the parcel value
   (setq first (car result))
   (setq odValue (cdr first))
   ; Get the Parcel size
   (setq second (cadr result))
   (setq odSize (cdr second))
   ; Get the parcel owner name
   (setq third (caddr result))
   (setq odOwner (cdr third))
)

;;;****************************************************************************
;;; Function: SetFieldValue
;;;
;;; With the Object Data value SET the feature layer attribute 
;;; tables field value using the ArcGIS for AutoCAD API 
;;; 'esri_attributes_set'.
;;;
;;; Prerequisites:
;;;   - "Owner", "ParcelSize" and "Value" are hardcoded
;;;     attribute field names.
;;;
(defun SetFieldValue ()
   ; `esri_attributes_set` This function adds or modifies 
   ; feature attributes on an entity of a feature layer
    (esri_attributes_set 
     eName
     flName
     (list 
       (cons "Owner" odOwner) 
       (cons "ParcelSize" odSize) 
       (cons "Value" odValue)
    ))
)

