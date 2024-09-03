;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO CREATE CUSTOM ARCGIS FOR AUTOCAD STOP SIGN FEATURES
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:createCustomStopSignFeatures ()
  
  ; Set properties for the ArcGIS for AutoCAD document feature layer
  (setq flName "Street_Signs")
  (setq geomType "POINT")
  (setq layerFilter "LayerStreetSigns") ; CAD layer must already exist
  
  ; Set an ArcGIS for AutoCAD attribute field and attribute value
  (setq attName "Sign_Type") 
  (setq attValue "Stop sign")
    
  ; Set the block for block symbol assignment
  (setq blockName "STOP") ; Block must exist and be on same layer as feature layer
  
  ; Create the ArcGIS for AutoCAD document feature layer if it doesn't exist and assign it the ArcGIS for AutoCAD attribute field
  (setq listFLNames (esri_docfeaturelayer_names))
  (if (not (member flName listFLNames))
    (progn
      (esri_docfeaturelayer_add flName
        (list
          (cons "GEOMTYPE" geomType)
          (cons "LAYERFILTER" layerFilter)
        )
      )
      (esri_fielddef_add flName
        (list
        (cons "NAME" attName)
        )
      )
    )
  )
  
  ; Create feature using the assigned block
  (command "INSERT" blockName (getpoint) "1" "" "")
    
  ; Select the ArcGIS for AutoCAD feature layer and loop through each entity
  (setq featureLayerSelection (esri_featurelayer_select flName))
  (setq featureLayerLength (sslength featureLayerSelection))
  (setq entCount 0)
  (repeat featureLayerLength 
    
    ; Select each entity and gather its block assignment
    (setq ss (ssadd))
    (setq entName (ssname featureLayerSelection entCount))
    (ssadd entName ss)
    (setq entData (entget entName))
    (setq entBlockData (cdr (assoc 2 entData)))

    ; If the block assignment matches, assign the ArcGIS for AutoCAD attribute value
    (if (= blockName entBlockData)
      (progn
      (esri_attributes_set entName flName
          (list
          (cons attName attValue)
          )
        )
      )
    )
    (setq entCount (+ 1 entCount))
  )
) 

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO CREATE CUSTOM ARCGIS FOR AUTOCAD YIELD SIGN FEATURES
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:createCustomYieldSignFeatures ()
    
  ; Set properties for the ArcGIS for AutoCAD document feature layer
  (setq flName "Street_Signs")
  (setq geomType "POINT")
  (setq layerFilter "LayerStreetSigns") ; CAD layer must already exist
  
  ; Set an ArcGIS for AutoCAD attribute field and attribute value
  (setq attName "Sign_Type") 
  (setq attValue "Yield sign")
  
  ; Set the block for block symbol assignment
  (setq blockName "YIELD")
   
  ; Create the ArcGIS for AutoCAD document feature layer if it doesn't exist and assign it the ArcGIS for AutoCAD attribute field
  (setq listFLNames (esri_docfeaturelayer_names))
  (if (not (member flName listFLNames))
    (progn
      (esri_docfeaturelayer_add flName
        (list
          (cons "GEOMTYPE" geomType)
          (cons "LAYERFILTER" layerFilter)
        )
      )
      (esri_fielddef_add flName
        (list
        (cons "NAME" attName)
        )
      )
    )
  )
    
  ; Create feature using the assigned block
  (command "INSERT" blockName (getpoint) "1" "" "")
    
  ; Select the feature layer and loop through each entity
  (setq featureLayerSelection (esri_featurelayer_select flName))
  (setq featureLayerLength (sslength featureLayerSelection))
  (setq entCount 0)
  (repeat featureLayerLength 
      
    ; Select each entity and gather its block assignment
    (setq ss (ssadd))
    (setq entName (ssname featureLayerSelection entCount))
    (ssadd entName ss)
    (setq entData (entget entName))
    (setq entBlockData (cdr (assoc 2 entData)))

    ; If the block assignment matches, assign the ArcGIS for AutoCAD attribute value
    (if (= blockName entBlockData)
      (progn
        (esri_attributes_set entName flName
          (list
            (cons attName attValue)
          )
        )
      )
    )
    (setq entCount (+ 1 entCount))
  )
)