# Use Place Multiple Labels (Sample)
This sample AutoLISP command function places labels from multiple ArcGIS for AutoCAD attribute fields at user-designated locations on entities in an ArcGIS for AutoCAD feature layer. 

![Cover_](https://media.devtopia.esri.com/user/7561/files/07992897-ed9c-46ef-b3e9-d40e129ea494)

## Use case
This sample AutoLISP command function places multiple labels on parcels in Houston, Texas.

## How it works
The user designates the ArcGIS for AutoCAD feature layer to operate within and the number of labels to place on entities from ArcGIS for AutoCAD attribute fields in the designated feature layer. For each round of labeling, the user designates the ArcGIS for AutoCAD attribute field containing the label values and the text size for the labels. For every entity in the ArcGIS for AutoCAD feature layer, the user chooses where to place the label and the label is placed with the [esri_label_place](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-label-place.htm) API. 

## How to use the sample
1. To prepare, download the [PlaceMultipleLabels.lsp](https://devtopia.esri.com/emil9669/AFA-Samples/blob/main/SampleCodeAndDemos/PlaceMultipleLabels/PlaceMultipleLabels.lsp) file from the GitHub folder, and download and open the [PlaceMultipleLabels_Sample.dwg](https://devtopia.esri.com/emil9669/AFA-Samples/blob/main/SampleCodeAndDemos/PlaceMultipleLabels/PlaceMultipleLabels_Sample.dwg) file from the GitHub folder. The AutoCAD sample drawing contains an ArcGIS for AutoCAD document feature layer of land parcels with ArcGIS for AutoCAD attributes for lot number, owner, lot size, and other parcel information. Water infrastructure document feature layers are included for additional context.
2. View the parcel data in ArcGIS for AutoCAD.

      ![Before_](https://media.devtopia.esri.com/user/7561/files/4a8c784e-d7f6-4913-ab5a-079a61d50955)

3. In the **Esri Contents** pane, on the **Parcels** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. Place 3 labels on each parcel, for the lot number (from the **LotNumber** attribute field), the owner (from the **Owner** attribute field), and the lot size (from the **Size** attribute field).

      ![Attributes_](https://media.devtopia.esri.com/user/7561/files/a9e91587-7afa-46bf-8a12-f3461e19d589)

4. Load the LSP file from your computer and then type "placeMultipleLabels" in the command line to access the custom tool.

      ![CommandLine_](https://media.devtopia.esri.com/user/7561/files/9d0aae11-029d-4daf-9094-b400f7dae359)
      
5. Type the ArcGIS for AutoCAD feature layer, "Parcels".
6. Type the number of labels to place on each entity from ArcGIS for AutoCAD attribute fields, "3". 
7. Type an ArcGIS for AutoCAD attribute field to be used for labeling, "LotNumber".
8. Type the text size for the lot number labels, "6".
9. Click the location for each lot number label to be placed, in the center of the parcels.
10. Type the next ArcGIS for AutoCAD attribute field to be used for labeling, "Owner".
11. Type the text size for the ownership labels, "10".
12. Click the location for each ownership label to be placed, below the lot number labels.
13. Type the next ArcGIS for AutoCAD attribute field to be used for labeling, "Size".
14. Type the text size for the lot size labels, "6".
15. Click the location for each lot size label to be placed, above the lot number labels.
16. Each parcel has 3 labels placed appropriately. 
            
      ![After_](https://media.devtopia.esri.com/user/7561/files/1a664400-3a64-42a2-94f0-cad6d9304601)

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample PlaceMultipleLabels.lsp
```LISP
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
```

## Relevant API
_The **placeMultipleLabels** sample command uses the following ArcGIS for AutoCAD Lisp API functions:_

- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.

- [esri_label_place](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-label-place.htm) - This function creates a new text entity from the content of an existing field of a web or document feature layer.
