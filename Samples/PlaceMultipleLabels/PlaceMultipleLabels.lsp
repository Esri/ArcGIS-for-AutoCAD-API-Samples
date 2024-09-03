;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO PLACE MULTIPLE LABELS FROM MULTIPLE ARCGIS FOR AUTOCAD ATTRIBUTE FIELDS AT USER-DESIGNATED LOCATIONS ON ENTITIES IN AN ARCGIS FOR AUTOCAD FEATURE LAYER
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:placeMultipleLabels()
   
   ; Get and select the feature layer
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq featureLayerSelection (esri_featurelayer_select featureLayer))
  (setq featureLayerLength (sslength featureLayerSelection))
  
  ; Get the number of attribute fields to be used for labeling, and loop through this many iterations of label placement
  (setq numLabels (getint "Enter the number of labels to be placed : "))
  (setq labelCount 0)
  (repeat numLabels
    
      ; Get the attribute field to create labels from and the text size for the labels
      (setq labelField (getstring "Enter attribute field name for labeling : ")) 
      (setq textSize (getreal "Enter label text size : "))
    
    ; Loop through each entity in the feature layer 
    (setq entCount 0)
    (repeat featureLayerLength 
      (setq ss (ssadd))
      (setq entName (ssname featureLayerSelection entCount))
      (ssadd entName ss)
      (setq entData (entget entName))

      ; Highlight the selected entity
      (redraw entName 3)

      ; Generate the label for the selected entity and place it at the desired location with the designated text size
      (esri_label_place featureLayer labelField entName 
      (getpoint "\nSelect label location or press Enter to skip") textSize)
      
      ; Redraw the entity without highlight
      (entmod entData)
      (redraw entName)
      
      (setq entCount (+ 1 entCount))
    )
  (setq labelCount (+ 1 labelCount))
  )
)