# Use Create Custom Features Toolbar (Sample)
The sample AutoLISP command functions in the provided custom user interface (CUIX) file add custom features to an ArcGIS for AutoCAD document feature layer from custom toolbar buttons and assign them ArcGIS for AutoCAD attribute values. 

![Cover_](https://media.devtopia.esri.com/user/7561/files/c58b7dfe-905f-4a83-a57d-a3785a0847ea)

## Use case
These sample AutoLISP command functions create stop sign and yield sign features in Aledo, TX.

## How it works
The LSP file contains multiple commands, each adding a custom feature to an ArcGIS for AutoCAD document feature layer and assigning it an ArcGIS for AutoCAD attribute value. The ArcGIS for AutoCAD document feature layer is created and assigned an ArcGIS for AutoCAD attribute field if it does not already exist.  A CUIX file is prepared that stores the LSP file, contains custom commands that call the commands from the LSP file, and assigns these custom commands to a custom toolbar with custom buttons. Once users load the CUIX and LSP files, they can access and dock the custom toolbar and click the buttons to add an ArcGIS for AutoCAD document feature layer and custom features. 

## Use the sample
1. To prepare, download the [CreateCustomFeaturesToolbar.lsp](https://devtopia.esri.com/emil9669/AFA-Samples/blob/main/SampleCodeAndDemos/CreateCustomFeaturesToolbar/CreateCustomFeaturesToolbar.lsp) file from the GitHub folder, download the [CreateCustomFeaturesToolbar_Sample.dwg](https://devtopia.esri.com/emil9669/AFA-Samples/blob/main/SampleCodeAndDemos/CreateCustomFeaturesToolbar/CreateCustomFeaturesToolbar_Sample.dwg) file from the GitHub folder, and download and open the [CreateCustomFeaturesToolbar.cuix](https://devtopia.esri.com/emil9669/AFA-Samples/blob/main/SampleCodeAndDemos/CreateCustomFeaturesToolbar/CreateCustomFeaturesToolbar.cuix) file from the GitHub folder. A street centerline ArcGIS for AutoCAD document feature layer is included for additional context.
2. View the map in ArcGIS for AutoCAD. The blocks in the drawing can be seen in the **Current Drawing Blocks** panel, and they are assigned to custom features. Add custom features from a custom toolbar.

    ![Before_](https://media.devtopia.esri.com/user/7561/files/d6dba830-9ceb-464f-b8b6-c4ede6bcd718)
    
3. Type "CUI" in the command line to access the **CUI Editor**.

    ![CUI_](https://media.devtopia.esri.com/user/7561/files/c691db19-6592-4e6b-8ec3-7a84d992feeb)
    
4. Under **All Customization Files**, right click on **Partial Customization Files** and select **Load partial customization file** to load the custom CUIX file from your directory.

    ![LoadPartial_](https://media.devtopia.esri.com/user/7561/files/d355240c-e374-4eef-95b4-8d46475a19a9)

5. The **All Customization Files** drop-down changes to **createcustomfeaturestoolbar.cuix**, the name of the custom CUIX file. Under **LISP Files**, right click on **CreateCustomFeaturesToolbar.lsp** and select **Load LISP** to load the LSP file from your directory to ensure the file path is recognized.

    ![LoadLisp_](https://media.devtopia.esri.com/user/7561/files/2a62089f-83be-4ae5-b2b7-ed2a992e1429)

6.  Two custom commands, **CreateCustomStopSignFeatures** and **CreateCustomYieldSignFeatures**, are added under **Command List**. Click on each command to see its properties. Each command is given a name, description, and a button image. For each custom command, the respective command from the LSP file is called in **Macro**.

    ![Properties_](https://media.devtopia.esri.com/user/7561/files/09ef2bad-9c1f-450c-8c52-db357af55856)

7. Under **Toolbars**, each custom command is added to the custom-created **CreateCustomFeatures** toolbar. Click on the toolbar to see the **Toolbar Preview**.

    ![ToolbarProperties_](https://media.devtopia.esri.com/user/7561/files/5d280b32-fa4b-46a6-b68f-5b4e29cb6363)

8. Hit **Apply** and **OK**. The **CUI Editor** closes and the custom toolbar is now available. Reopen the **Esri Contents** pane, if necessary. Dock the custom toolbar above the **Esri Contents** pane.

     ![ButtonsDocked_](https://media.devtopia.esri.com/user/7561/files/695ccef3-1a94-47ac-87fd-74c3f6573e3a)

9. Hover over each button with your mouse to see the button name and description pop-ups. Click on the **CreateCustomStopSignFeatures** button. The **Street_Signs** document feature layer is added in the **Esri Contents** pane. Place the new stop sign feature on the median near the intersection. Click on the **CreateCustomYieldSignFeatures** button to place the new yield sign feature along the right-turn slip lane. 

    ![After_](https://media.devtopia.esri.com/user/7561/files/0b36c609-bcc8-4b7e-8dd5-548af66ead1e)

11. In the **Esri Contents** pane, on the **Street_Signs** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. Stop sign and yield sign values are assigned accordingly in the **Sign_Type** ArcGIS for AutoCAD attribute field.

    ![AttributesAfter_](https://media.devtopia.esri.com/user/7561/files/db3036d3-bb9a-42f6-9ac5-06b2b2c3245d)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/126473c8-3a29-471a-94cc-d0e598658606

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample CreateCustomFeaturesToolbar.lsp
```LISP
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
```
## Relevant API
_The **createCustomStopSignFeatures** and **createCustomYieldSignFeatures** sample commands use the following ArcGIS for AutoCAD Lisp API functions:_
- [esri_docfeaturelayer_names](https://docdev.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-docfeaturelayer-names.htm) – This function retrieves the document feature layer names in the current drawing as a list of strings.

- [esri_docfeaturelayer_add](https://docdev.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-docfeaturelayer-add.htm) – This function adds a document feature layer definition to the AutoCAD drawing.

- [esri_fielddef_add](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-fielddef-add.htm) – This function adds a new field definition to an existing document feature layer. 

- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.

- [esri_attributes_set](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attribute-set.htm) – This function adds or modifies feature attributes on an entity of a feature layer.
