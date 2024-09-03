# Use Favorite Web Layers Toolbar (Sample)
The sample AutoLISP command functions in the provided custom user interface (CUIX) file add designated ArcGIS for AutoCAD Web Layers to the map from custom toolbar buttons. 

![Cover_](https://media.devtopia.esri.com/user/7561/files/0edf83a8-a88f-484f-9dd7-540c038b0387)

## Use case
These sample AutoLISP command functions add a parks ArcGIS for AutoCAD web feature layer and a watershed ArcGIS for AutoCAD web feature layer in Portland, Oregon. The web layers are the [USA Parks](https://www.arcgis.com/home/item.html?id=f092c20803a047cba81fbf1e30eff0b5) layer and the [Watershed Boundary Dataset HUC 12s](https://www.arcgis.com/home/item.html?id=b60aa1d756b245cf9db03a92254af878) layer, both available on Esri's [Living Atlas](https://livingatlas.arcgis.com/en/home/). 

## How it works
The LSP file contains multiple commands, each using the [esri_weblayer_add](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-weblayer-add.htm) API to add an ArcGIS for AutoCAD web feature layer by its URL. A CUIX file is prepared that stores the LSP file, contains custom commands that call the commands from the LSP file, and assigns these custom commands to a custom toolbar with custom buttons. Once users load the CUIX and LSP files, they can access and dock the custom toolbar and click the buttons to add web layers.

## Use the sample
1. To prepare, download the [FavoriteWebLayersToolbar.lsp](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/FavoriteWebLayersToolbar/FavoriteWebLayersToolbar.lsp) file from the GitHub folder, download the [FavoriteWebLayersToolbar.cuix](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/FavoriteWebLayersToolbar/FavoriteWebLayersToolbar.cuix) file from the GitHub folder, and download and open the [FavoriteWebLayersToolbar_Sample.dwg](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/FavoriteWebLayersToolbar/FavoriteWebLayersToolbar_Sample.dwg) file from the GitHub folder. The AutoCAD sample drawing does not contain ArcGIS for AutoCAD web feature layers or document feature layers. 
2. View the map in ArcGIS for AutoCAD. Add web layers from a custom toolbar.

    ![Before_](https://media.devtopia.esri.com/user/7561/files/2cad3439-33bd-48b2-995c-49f05a97d901)
    
3. Type "CUI" in the command line to access the **CUI Editor**.

    ![CUI_](https://media.devtopia.esri.com/user/7561/files/ab25dc69-fb1f-4d01-ab84-bd9e8d027c36)
    
4. Under **All Customization Files**, right click on **Partial Customization Files** and select **Load partial customization file** to load the custom CUIX file from your directory.

    ![Partial_](https://media.devtopia.esri.com/user/7561/files/ec4e4c37-d335-408a-9abf-5ecb261d32f8)

5. The **All Customization Files** drop-down changes to **favoriteweblayerstoolbar.cuix**, the name of the custom CUIX file. Under **LISP Files**, right click on **FavoriteWebLayersToolbar.lsp** and select **Load LISP** to load the LSP file from your directory to ensure the file path is recognized.

    ![NewLisp_](https://media.devtopia.esri.com/user/7561/files/2ba1cce1-e78c-4227-9963-53e0462f7b76)

6.  Two custom commands, **AddFavoriteWatershedWebLayer** and **AddFavoriteParksWebLayer**, are added under **Command List**. Click on each command to see its properties. Each command is given a name, description, and a button image. For each custom command, the respective command from the LSP file is called in **Macro**.

    ![NewCommand_](https://media.devtopia.esri.com/user/7561/files/4e3e8de4-1b4f-4bea-aada-0295d284186f)

7. Under **Toolbars**, each custom command is added to the custom-created **FavoriteWebLayers** toolbar. Click on the toolbar to see the **Toolbar Preview**.

    ![NEWCUIToolbar_](https://media.devtopia.esri.com/user/7561/files/84e7c59c-84c6-46e1-8d0a-b490101d0659)

8. Hit **Apply** and **OK**. The **CUI Editor** closes and the custom toolbar is now available. Reopen the **Esri Contents** pane, if necessary. Dock the custom toolbar above the **Esri Contents** pane.

     ![Docked_](https://media.devtopia.esri.com/user/7561/files/bbea823c-5554-45bd-9145-c398a27d5514)

9. Hover over each button with your mouse to see the button name and description pop-ups. Click on each button to run the AutoLISP commands. The ArcGIS for AutoCAD web feature layers are added to the map and in the **Esri Contents** pane. 

    ![After_](https://media.devtopia.esri.com/user/7561/files/110fa1b3-ae12-421d-85c3-3dbb998e2f34)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/61877045-76e0-4d6f-84c9-129bb17c8d66


## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample FavoriteWebLayersToolbar.lsp
```LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO ADD THE DESIGNATED ARCGIS FOR AUTOCAD PARKS WEB FEATURE LAYER BY ITS URL
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defun c:addParksWebLayer ()
  (esri_weblayer_add "https://services.arcgis.com/P3ePLMYs2RVChkJx/arcgis/rest/services/USA_Parks/FeatureServer")
)

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; COMMAND TO ADD THE DESIGNATED ARCGIS FOR AUTOCAD WATERSHED WEB FEATURE LAYER BY ITS URL
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
(defun c:addWatershedWebLayer ()
  (esri_weblayer_add "https://services.arcgis.com/P3ePLMYs2RVChkJx/arcgis/rest/services/Watershed_Boundary_Dataset_HUC_12s/FeatureServer")
)
```

## Relevant API
_The **addParksWebLayer** and **addWatershedWebLayer** sample commands use the following ArcGIS for AutoCAD Lisp API function:_
- [esri_weblayer_add](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-weblayer-add.htm) - This function adds a new map layer, imagery layer, or a web feature layer to the drawing using the specified URL. 
