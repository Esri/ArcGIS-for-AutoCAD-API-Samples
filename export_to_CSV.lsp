;ARCGIS FOR AUTOCAD SAMPLE LISP ROUTINES: EXPORT TO CSV

;****************************************************************************
;
; /#@\ Written by:  Randy Garcia,  Senior Product Engineer
; \@$/ Copyright (C) 2023 by ESRI, Inc.
;
;
;;;   THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
;;;   EXPRESS OR IMPLIED.  ALL WARRANTIES OF FITNESS FOR A
;;;   PARTICULAR PURPOSE AND OF MERCHANTABILITY ARE HEREBY DISCLAIMED.
;;;   You can copy modify and distribute but not sell this code
;****************************************************************************

(defun c:AFA_export2CSV ()
  (setq featureLayer (getstring "Name of Feature Layer? : "))
  (setq csvpath (getfiled "Create a CSV" (strcat featureLayer "_export") "csv" 1))
  (if (setq csvFile (open csvpath "w"))
      (progn
        (setq attString "")
        ;;start of field name processing
        (setq FieldNameList (esri_fielddef_names featureLayer))
        (foreach fieldName FieldNameList
          (setq attString (strcat attString fieldname ","))
        )
        (setq lineLength (strlen attString))
        (setq attString (substr attstring 1 (1- lineLength)))
        (write-line attString csvFile)
        ;;end of field name processing
        ;;start of field value processing
        (setq rawFieldResults (esri_featurelayer_getattributes featureLayer))
        (setq numberOfFeatures (length rawFieldResults))
        (if (< 500 numberOfFeatures) (alert "This may take a while"))
        (setq numberOfFields (length FieldNameList))
        (setq featureEntry "")
        (foreach entry rawFieldResults
          (setq nl entry)
          (foreach fieldValue nl
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
            (type fieldValue)
            (setq featureEntry (strcat featureEntry fieldValue ","))
          )
          (setq lineLength (strlen featureEntry))
          (setq featureEntry (substr featureEntry 1 (1- lineLength)))
          (write-line featureEntry csvFile)
          (setq featureEntry "")
        )
        (close csvFile)
        (alert (strcat "export complete: " csvpath))
        (startapp excel csvpath)
      )
      (princ "\nUnable to create/modify file.")
    )
)