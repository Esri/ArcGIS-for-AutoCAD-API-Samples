# Use Calculate New Field (Sample)
This sample AutoLISP command function calculates the values of a new ArcGIS for AutoCAD attribute field by applying a mathematical expression onto the values of other fields.

![Cover_](https://media.devtopia.esri.com/user/7561/files/186e1956-eebc-4179-9128-838155cb53c3)

## Use case
This sample AutoLISP command function calculates the floor area ratio (FAR) of homes in Calabasas, California. 

## How it works
The user designates the ArcGIS for AutoCAD feature layer to operate within, the mathematical operation to apply, two ArcGIS for AutoCAD attribute fields to undergo calculation, and a name for the new field to store the new values. A new ArcGIS for AutoCAD attribute field is created with the user-provided name using the [esri_fielddef_add](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-fielddef-add.htm) API to store the new values. For every entity in the ArcGIS for AutoCAD feature layer, the two attribute field values are gathered and the designated mathematical operation is performed on the values, then the newly calculated value is assigned to the new field prepared to store the value. The calculation runs whether the user inputs float, integer, or string attribute fields, as the values are converted appropriately. 

## Use the sample
1. To prepare, download the [CalculateNewField.lsp](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/CalculateNewField/CalculateNewField.lsp) file from the GitHub folder, and download and open the [CalculateNewField_Sample.dwg](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/CalculateNewField/CalculateNewField_Sample.dwg) file from the GitHub folder. The AutoCAD sample drawing contains an ArcGIS for AutoCAD document feature layer of land parcels with ArcGIS for AutoCAD attributes for building square footage, parcel square footage, and other parcel information.
2. View the parcel data in ArcGIS for AutoCAD.

    ![Before_](https://media.devtopia.esri.com/user/7561/files/a7a615e5-1445-480c-b712-fac854f88b13)

3. In the **Esri Contents** pane, on the **Land_Calabasas** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. Divide the building square footage by the parcel square footage to calculate the FAR in a new attribute field.

    ![NewAttributes_](https://media.devtopia.esri.com/user/7561/files/0b984e26-9d30-4dc9-9f95-704db0879d16)
    
4. Load the LSP file from your computer and then type "calculateNewField" in the command line to access the custom tool.

    ![CommandLine_](https://media.devtopia.esri.com/user/7561/files/e61614c3-59c8-496f-9b37-3120e2f5be3a)
    
5. Type the ArcGIS for AutoCAD feature layer, "Land_Calabasas".
6. A pop-up of calculation options appears. Type "D" for division.  

    ![Options_](https://media.devtopia.esri.com/user/7561/files/19c004f3-e313-4642-920d-fbf98ac42acd)
    
7. Type the first ArcGIS for AutoCAD attribute field for calculation (here, the field to divide), "BuildingSqFt".
8. Type the second ArcGIS for AutoCAD attribute field for calculation (here, the field to divide by), "ParcelSqFt".
9. Name a new ArcGIS for AutoCAD attribute field to store the new value, "FAR".
10. The ArcGIS for AutoCAD attribute table is successfully updated with the FAR values.
    
    ![NewAfter_](https://media.devtopia.esri.com/user/7561/files/04ab0597-91bf-4e83-a63b-4747955f6ee8)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/0004212d-c043-4493-85a2-844b2f2f9c3c

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample CalculateNewField.lsp
```LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; CALCULATE THE VALUES OF A NEW ARCGIS FOR AUTOCAD ATTRIBUTE FIELD BY APPLYING A MATHEMATICAL EXPRESSION ONTO THE VALUES OF OTHER FIELDS
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:calculateNewField ()
  
  ; Get and select the feature layer
  (setq featureLayer (getstring "Enter the Feature Layer name: "))
  (setq featureLayerSelection (esri_featurelayer_select featureLayer))
  (setq featureLayerLength (sslength featureLayerSelection))
  
  ; Gather the desired mathematical operation to apply 
  (initget "Multiply Divide Add Subtract")
  (setq operation (strcase (getkword "Enter an option [Multiply/Divide/Add/Subtract]: ")))
  
  ; Get the names of the two attribute fields to undergo calculation
  (setq firstField (getstring "Enter the first field name: "))
  (setq secondField (getstring "Enter the second field name: "))
  
  ; Name and create a new float attribute field to hold the newly calculated values
  (setq newField (getstring "Enter name for new field to be created: "))
  (esri_fielddef_add featureLayer
    (list
      (cons "name" newField)
      (cons "Type" "Float")
    )
  )
  
  ; Loop through each entity in the feature layer
  (setq entCount 0)
  (repeat featureLayerLength 
    (setq ss (ssadd))
    (setq entName (ssname featureLayerSelection entCount))
    (ssadd entName ss)
    
    ; Get the entity's first attribute field value for calculation
    (setq firstFieldAttributes
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" featureLayer)
          (cons "FIELDNAME" firstField)
        )
      )
    )
    (setq firstFieldValue (cdr (car firstFieldAttributes)))  
    
    ; Convert the value to a float, if it is a string or integer 
    (cond
      ((= (type firstFieldValue) 'STR )
        (setq firstFieldValue (atof firstFieldValue))
      )
      ((= (type firstFieldValue) 'INT )
        (setq firstFieldValue (float firstFieldValue))
      )
    )

    ; Get the entity's second attribute field value for calculation
    (setq secondFieldAttributes
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" featureLayer)
          (cons "FIELDNAME" secondField)
        )
      )
    )    
    (setq secondFieldValue (cdr (car secondFieldAttributes))) 
    
    ; Convert the value to a float, if it is a string or integer      
    (cond
      ((= (type secondFieldValue) 'STR )
        (setq secondFieldValue (atof secondFieldValue))
      )
      ((= (type secondFieldValue) 'INT )
        (setq secondFieldValue (float secondFieldValue))
      )
    )
    
    ; Perform the appropriate operator calculation 
    (if (equal operation "MULTIPLY")
      (setq finalValue (* firstFieldValue secondFieldValue))
      (if (equal  operation "DIVIDE")
        (setq finalValue (/ firstFieldValue secondFieldValue))
        (if (equal operation "ADD")
          (setq finalValue (+ firstFieldValue secondFieldValue))
          (if (equal operation "SUBTRACT")
            (setq finalValue (- firstFieldValue secondFieldValue))
            (princ "Not an option")
          )
        )
      )
    ) 

    ; Assign the calculated value to the new field
    (esri_attributes_set
      entName
      featureLayer
      (list 
        (cons newField finalValue)
      )
    )

    (setq entCount (+ 1 entCount))
  )
)
```

## Relevant API
_The **calculateNewField** sample command uses the following ArcGIS for AutoCAD Lisp API functions:_
- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.

- [esri_fielddef_add](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-fielddef-add.htm)- This function adds a new field definition to an existing document feature layer.

- [esri_attributes_get](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) – This function gets an associated list of the field names and their attribute value.

- [esri_attributes_set](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attribute-set.htm) – This function adds or modifies feature attributes on an entity of a feature layer.
