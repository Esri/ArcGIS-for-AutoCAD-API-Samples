# Use Concatenate Fields To Label (Sample)
This sample AutoLISP command function concatenates values from two ArcGIS for AutoCAD attribute fields with a delineator to fill a new string attribute field and generates labels from the new attribute field.
![Cover9_](https://media.devtopia.esri.com/user/7561/files/1d3d59e9-8c08-4e96-a210-edaf2f455b20)

## Use case
This sample AutoLISP command function combines street numbers and street names to create home addresses for parcels in Rancho Palos Verdes, California, and generates labels from the addresses. 

## How it works
The user designates the ArcGIS for AutoCAD feature layer to operate within, two ArcGIS for AutoCAD attribute fields to concatenate, a delineator, and a name for the new attribute field to store the new values. A new ArcGIS for AutoCAD string attribute field is created with the user-provided name using the [esri_fielddef_add](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-fielddef-add.htm) API to store the new values. For every entity in the ArcGIS for AutoCAD feature layer, the two attribute field values are gathered and concatenated with the designated delineator, then the newly concatenated value is assigned to the new field prepared to store the value. If the user selects fields that are integers or floats, the values are converted to strings for concatenation. Labels are generated from the new attribute field with the [esri_label_generate](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-label-generate.htm) API. 

## Use the sample
1. To prepare, download the [ConcatenateFieldsToLabel.lsp](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/ConcatenateFieldsToLabel/ConcatenateFieldsToLabel.lsp) file from the GitHub folder, and download and open the [ConcatenateFieldsToLabel_Sample.dwg](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/ConcatenateFieldsToLabel/ConcatenateFieldsToLabel_Sample.dwg) file from the GitHub folder. The AutoCAD sample drawing contains an ArcGIS for AutoCAD document feature layer of parcels with ArcGIS for AutoCAD attributes for street numbers, street names, and other parcel information.
2. View the parcel data in ArcGIS for AutoCAD.

    ![Before9_](https://media.devtopia.esri.com/user/7561/files/7202b64d-4688-4e7b-a3d4-8529915ad719)

3. In the **Esri Contents** pane, on the **Land_RPV** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. Combine the street numbers (from the **StreetNumber** attribute field) and street names (from the **StreetName** attribute field) to create addresses with spaces separating the values, and generate labels from the addresses.

    ![NewAttributes_](https://media.devtopia.esri.com/user/7561/files/bb8db5e0-84a6-4d91-be40-05c82ffde515)
    
4. Load the LSP file from your computer and then type "concatenateFieldsToLabel" in the command line to access the custom tool.

    ![CommandLine_](https://media.devtopia.esri.com/user/7561/files/7a72b400-cea6-4d36-a2a4-1b27ba098240)

5. Type the ArcGIS for AutoCAD feature layer, "Land_RPV".
6. Type the first ArcGIS for AutoCAD attribute field to concatenate, "StreetNumber".
7. Type the second ArcGIS for AutoCAD attribute field to concatenate, "StreetName".
8. Type a space as the delineator to separate the street numbers and street names, " ".
9. Name a new ArcGIS for AutoCAD attribute field to store the new values, "Address".
10. The ArcGIS for AutoCAD attribute table is successfully updated with the addresses, and labels are generated from the new **Address** attribute field.
  
    ![NewAfter_](https://media.devtopia.esri.com/user/7561/files/722053dc-6373-4e67-b68a-52b96ac7e767)
    ![AfterLabels9_](https://media.devtopia.esri.com/user/7561/files/6d7cea69-2476-4b20-aa75-0078b6c047ac)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/f6c7c515-d3b6-458e-96af-b34369aa17a7

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample ConcatenateFieldsToLabel.lsp
```LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; CONCATENATE VALUES FROM TWO ARCGIS FOR AUTOCAD ATTRIBUTE FIELDS WITH A DELINEATOR TO FILL A NEW STRING ATTRIBUTE FIELD AND GENERATE LABELS
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:concatenateFieldsToLabel()
  
  ; Get and select the feature layer
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq featureLayerSelection (esri_featurelayer_select featureLayer))
  (setq featureLayerLength (sslength featureLayerSelection))
  
  ; Get the names of the attribute fields to become the first and second parts of the new string field, and a delineator to separate them
  (setq firstField (getstring "Enter the first attribute field name : "))
  (setq secondField (getstring "Enter the second attribute field name : "))
  (setq delineator (getstring T "Enter a delineator to separate the two fields: "))
  
  ; Name and create a new empty string field to hold the newly concatenated values
  (setq newTextField (getstring "Enter the new text field name to be created : "))
  (esri_fielddef_add featureLayer
    (list
      (cons "name" newTextField)
      (cons "Type" "String")
    )
  )

  ; Loop through each entity in the feature layer
  (setq entCount 0)
  (repeat featureLayerLength 
    (setq textFill "") 
    (setq ss (ssadd))
    (setq entName (ssname featureLayerSelection entCount))
    (ssadd entName ss)
    
    ; Get the entity's first attribute field value
    (setq firstAttributes
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" featureLayer)
          (cons "FIELDNAME" firstField)
        )
      )
    ) 
    (setq firstValue (cdr (car firstAttributes)))
 
    ; Convert the first attribute field value to a string, if it is a float or integer 
    (cond
      ((= (type firstValue) 'REAL )
        (setq firstValue (rtos firstValue))
      )
      ((= (type firstValue) 'INT )
        (setq firstValue (itoa firstValue))
      )
    )
    
    ; Get the entity's second attribute field value
    (setq secondAttributes
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" featureLayer)
          (cons "FIELDNAME" secondField)
        )
      )
    ) 
    (setq secondValue (cdr (car secondAttributes)))   
    
    ; Convert the second attribute field value to a string, if it is a float or integer
    (cond
      ((= (type secondValue) 'REAL )
        (setq secondValue (rtos secondValue))
      )
      ((= (type secondValue) 'INT )
        (setq secondValue (itoa secondValue))
      )
    )
    
    ; Concatenate the fields with the delineator, and assign the new text to the new field
    (setq textFill (strcat firstValue delineator secondValue))
    (esri_attributes_set
      entName
      featureLayer
      (list 
        (cons newTextField textFill)
      )
    )
    
    (setq entCount (+ 1 entCount))
  )
  
  ; Generate labels from the new field with the chosen OFFSET and TEXTSIZE
  (esri_label_generate featureLayer newTextField
    (list
      (cons "OFFSET" '(0 0 0))
      (cons "TEXTSIZE" 9)
    )
  )  
)
```

## Relevant API
_The **concatenateFieldsToLabel** sample command uses the following ArcGIS for AutoCAD Lisp API functions:_

- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.

- [esri_fielddef_add](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-fielddef-add.htm)- This function adds a new field definition to an existing document feature layer.

- [esri_attributes_get](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) – This function gets an associated list of the field names and their attribute value.

- [esri_attributes_set](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attribute-set.htm) – This function adds or modifies feature attributes on an entity of a feature layer.

- [esri_label_generate](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-label-generate.htm) - This function generates labels for the selected features of the specified feature layer using values from the specified attribute field.
