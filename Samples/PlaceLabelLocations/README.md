# Use Place Label Locations (Sample)
This sample AutoLISP command function places labels from an ArcGIS for AutoCAD attribute field at user-designated locations on entities in an ArcGIS for AutoCAD feature layer. 

![Cover_](https://media.devtopia.esri.com/user/7561/files/6babac62-44e3-425a-a47a-d84b13fc1915)

## Use case
This sample AutoLISP command function places labels on storm drains in Houston, Texas. 

## How it works
The user designates the ArcGIS for AutoCAD feature layer to operate within, the attribute containing the label values, and the text size for the labels. For every entity in the ArcGIS for AutoCAD feature layer, the user chooses where to place the label, and the label is placed with the [esri_label_place](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-label-place.htm) API. 

## How to use the sample
1. Download the [PlaceLabelLocations.lsp](https://devtopia.esri.com/emil9669/AFA-Samples/blob/main/SampleCodeAndDemos/PlaceLabelLocations/PlaceLabelLocations.lsp) file from the GitHub folder, and download and open the [PlaceLabelLocations_Sample.dwg](https://devtopia.esri.com/emil9669/AFA-Samples/blob/main/SampleCodeAndDemos/PlaceLabelLocations/PlaceLabelLocations_Sample.dwg) file from the GitHub folder. The AutoCAD sample drawing contains an ArcGIS for AutoCAD point document feature layer of storm drains with ArcGIS for AutoCAD attributes. A stormwater pipe document feature layer is included for additional context. 
2. View the storm drain data in ArcGIS for AutoCAD.

   ![Before_](https://media.devtopia.esri.com/user/7561/files/21f92c74-a766-4edf-9dd7-11a993fc3f3f)

3. In the **Esri Contents** pane, on the **Storm_Drain** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. Place a drain name label on each storm drain from the **aec_Name** attribute field. 

   ![Attributes_](https://media.devtopia.esri.com/user/7561/files/633460fc-f4de-4e90-a244-c168fea8ee23)

4. Load the LSP file from your computer and then type "placeMultipleLabels" in the command line to access the custom tool.

   ![CommandLine_](https://media.devtopia.esri.com/user/7561/files/8283a9b2-781a-4a95-9033-44f159119785)
   
5. Type the ArcGIS for AutoCAD feature layer, "Storm_Drain".
6. Type the ArcGIS for AutoCAD attribute field to be used for labeling, "aec_Name".
7. Type the text size for the drain name labels, "4".
8. Click the location for each label to be placed.
9. Each storm drain has a drain name label. 

   ![After_](https://media.devtopia.esri.com/user/7561/files/4434a23f-2524-471e-8340-60a9abd043e0)

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample PlaceLabelLocations.lsp
```LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO PLACE LABELS FROM AN ARCGIS FOR AUTOCAD ATTRIBUTE FIELD AT USER-DESIGNATED LOCATIONS ON ENTITIES IN AN ARCGIS FOR AUTOCAD FEATURE LAYER
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:placeLabelLocations()
   
   ; Get the feature layer, the attribute to generate labels from, and the text size for the labels, and select the feature layer
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq featureLayerSelection (esri_featurelayer_select featureLayer))
  (setq featureLayerLength (sslength featureLayerSelection))
  (setq labelField (getstring "Enter the attribute field name for the labels : "))
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
    (esri_label_place featureLayer labelField entName (getpoint "\nSelect label location or press Enter to skip") textSize)
    
    ; Redraw the entity without highlight
    (entmod entData)
    (redraw entName)
    
    (setq entCount (+ 1 entCount))
  )
)
```
## Relevant API
_The **placeLabelLocations** sample command uses the following ArcGIS for AutoCAD Lisp API functions:_

- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.

- [esri_label_place](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-label-place.htm) - This function creates a new text entity from the content of an existing field of a web or document feature layer.
