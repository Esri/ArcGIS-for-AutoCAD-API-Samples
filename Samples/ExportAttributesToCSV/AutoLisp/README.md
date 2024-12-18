# Export Attributes to CSV

This sample routine exports a feature layers attributes to a CSV file.

![Cover_](../../../Resources/Images/ExportCSV-1.png)

## Description
This example exports home attributes from Louisville, Kentucky to a well-formatted CSV file, suitable for utilization in Excel or other applications. Within the AutoCAD sample drawing, there is a polygon document feature layer depicting a cluster of homes in Louisville, Kentucky, each accompanied by a range of attributes.

## Use the sample  

1. Open the [ExportToCSV_Sample.dwg](ExportToCSV_Sample.dwg) drawing and load the [ExportToCSV.lsp](ExportToCSV.lsp)  file.

3. To better understand our sample drawing, open the attribute table of the "Houses" layer and review the list of attributes and field names.

4. To export these attributes to a CSV run the ```EXPORTTOCSV``` command. Select a file path where the file should be written to. 

6. Open the newly created csv in your application of choice and explore the same attributes seen in ArcGIS for AutoCAD.

    ![Excel_](../../../Resources/Images/ExportCSV-6.png)

## How it works

1. Get the name of the feature layer from the user

2. Create a blank CSV file

3. Get the field names of the feature layer using [```esri_fielddef_names```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-fielddef-names.htm)

4. Get all the attributes of the feature layer using [```esri_featurelayer_getattributes```](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-getattributes.htm)

5. Write the field names and attributes to the CSV file.

   

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample ExportToCSV.lsp
``` LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; This sample routine exports a feature layer's attributes to a CSV file.
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:exportToCSV ()
  
  ; Choose the feature layer and the file location for the new CSV. Present user with file picker window. 
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq csvPath (getfiled "Create a CSV" (strcat featureLayer "_export") "csv" 1))
  
  ; Create a new CSV file and open it for write
  (if (setq csvFile (open csvPath "w")) 
      (progn     
        
        ;; Get and format the attribute field name of the entire feature layer. Write to CSV as the header info. 
        (setq fieldNameList (esri_fielddef_names featureLayer))
        (setq attString "")
        (foreach fieldName fieldNameList
          (setq attString (strcat attString fieldName ","))
        )
        (setq lineLength (strlen attString))
        (setq attString (substr attstring 1 (1- lineLength)))
        (write-line attString csvFile)

        
        ;; Get and format the attribute values of the entire feature layer.
        (setq rawFieldResults (esri_featurelayer_getattributes featureLayer))
        (setq numberOfFeatures (length rawFieldResults))
        (if (< 500 numberOfFeatures) (alert "This may take a while"))
        (setq featureEntry "")
        ;; loop through every attribute value
        (foreach entry rawFieldResults
          (setq attFieldPair entry)
          ;; convert each field value as needed to a string          
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
            ;; add commas between each attribute value as required by a CSV
            (setq featureEntry (strcat featureEntry fieldValue ","))
          )
          (setq lineLength (strlen featureEntry))
          ;; remove any trailing commas and write the attribute value to the CSV
          (setq featureEntry (substr featureEntry 1 (1- lineLength)))
          (write-line featureEntry csvFile)
          (setq featureEntry "")
        )

        ; Close the file and show export completion
        (close csvFile)
        (alert (strcat "export complete: " csvPath))
      )
      (princ "\nUnable to create/modify file.")
    )
)
```

## Relevant  API

- [esri_fielddef_names](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-fielddef-names.htm) – This function returns a list of field names for an existing document or web feature layer.

- [esri_featurelayer_getattributes](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-getattributes.htm) – This function returns a list of associated lists of all the attributes of all the features of the specified feature layer in the drawing.
