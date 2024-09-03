# Use Unit Conversion (Sample)

This sample AutoLISP command function converts values in one ArcGIS for AutoCAD attribute field to a different unit in a new attribute field using a conversion rate.

![Cover_](https://media.devtopia.esri.com/user/7561/files/e556da42-4b86-4fef-8438-f9a7cf5ff7b2)

## Use case 
This sample AutoLISP command function converts contour line elevation values in Riverside, California, from meters to feet.

## How it works
The user designates the ArcGIS for AutoCAD feature layer to operate within, the ArcGIS for AutoCAD attribute field containing the existing values, the conversion rate, and a name for the new field to store the new values. A new ArcGIS for AutoCAD float attribute field is created with the user-provided name using the [esri_fielddef_add](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-fielddef-add.htm) API to store the new values. For every entity in the ArcGIS for AutoCAD feature layer, the existing value is gathered, the conversion rate is applied to the existing value, and the value in the new unit is applied to the new field prepared to store the value. If the user selects a string field, the values will be converted to floats for calculation.

## Use the sample
1. To prepare, download the [UnitConversion.lsp](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/UnitConversion/UnitConversion.lsp) file from the GitHub folder, and download and open the [UnitConversion_Sample.dwg](https://devtopia.esri.com/amb13827/AFA-Samples/blob/main/SampleCodeAndDemos/UnitConversion/UnitConversion_Sample.dwg) file from the GitHub folder. The AutoCAD sample drawing contains an ArcGIS for AutoCAD document feature layer of contour lines with an ArcGIS for AutoCAD attribute field of elevation values in meters.
2. View the contour line data in ArcGIS for AutoCAD.

    ![Before_](https://media.devtopia.esri.com/user/7561/files/3b6c6362-0d58-4051-846f-275fa53ffb6a)

3. In the **Esri Contents** pane, on the **Contour_Lines** document feature layer, click the **Attribute Table** button to view the ArcGIS for AutoCAD attributes. Populate a new attribute field with the meters to feet unit conversion of the **Elevation_Meters** field.

    ![NewAttributes_](https://media.devtopia.esri.com/user/7561/files/b1a6df7a-eb0a-42c3-8b0e-50c10fdc73b9)

4. Load the LSP file from your computer and then type "unitConversion" in the command line to access the custom tool. 
    
    ![CommandLine_](https://media.devtopia.esri.com/user/7561/files/d49925ec-1742-473e-98ad-335be7a37cfe)
    
5. Type the ArcGIS for AutoCAD feature layer, "Contour_Lines".
6. Type the ArcGIS for AutoCAD attribute field containing the original unit values, "Elevation_Meters".
7. Type the conversion rate, "3.28024", which is the meters to feet conversion rate. 
8. Name a new ArcGIS for AutoCAD attribute field to store the converted unit values, "Elevation_Feet". 
9. The ArcGIS for AutoCAD attribute table is successfully updated with the elevation values in feet.
    
    ![NewAfter_](https://media.devtopia.esri.com/user/7561/files/2373b9a9-cb96-450a-ae1c-7e228624a83b)

## Demonstration video

https://media.devtopia.esri.com/user/7561/files/4d50052a-8785-42ce-8650-dd77b622ab23

## Sample AutoLISP
ArcGIS for AutoCAD AutoLISP sample UnitConversion.lsp
```LISP
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
; CONVERT VALUES IN ONE ARCGIS FOR AUTOCAD ATTRIBUTE FIELD TO A DIFFERENT UNIT IN A NEW ATTRIBUTE FIELD USING A CONVERSION RATE
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

(defun c:unitConversion ()
  
  ; Get and select the feature layer
  (setq featureLayer (getstring "Enter the Feature Layer name : "))
  (setq featureLayerSelection (esri_featurelayer_select featureLayer))
  (setq featureLayerLength (sslength featureLayerSelection))
  
  ; Get the name of the attribute field containing the original values and the conversion rate for the new units
  (setq originField (getstring "Enter the origin field name : "))
  (setq multiplier (atof(getstring "Enter the constant to multiply by/the conversion rate : ")))
  
  ; Name and create a new float attribute field to hold the newly calculated values
  (setq destField (getstring "Enter name for new field to be created : "))
  (esri_fielddef_add featureLayer
    (list
      (cons "name" destField)
      (cons "Type" "Float")
    )
  )
  
  ; Loop through each entity in the feature layer
  (setq entCount 0)
  (repeat featureLayerLength 
    (setq ss (ssadd))
    (setq entName (ssname featureLayerSelection entCount))
    (ssadd entName ss)
    
    ; Get the entity's attribute value in the original unit from the original values attribute field, and set the value to a float if it is a string
    (setq fieldAttributeOrigin
      (esri_attributes_get entName 
        (list 
          (cons "FLNAME" featureLayer)
          (cons "FIELDNAME" originField)
        )
      )
    )    
    (setq originValue (cdr (car fieldAttributeOrigin)))        
    (cond ((= (type originValue) 'STR) (setq originValue (atof originValue))))
    
    ; Convert the value into the new unit with the conversion rate, and assign the new value to the new field
    (setq destValue (* multiplier originValue))
    (esri_attributes_set
      entName
      featureLayer
      (list 
        (cons destField destValue)
      )
    )
    
    (setq entCount (+ 1 entCount))
  )
)
```
## Relevant API

_The **unitConversion** sample command uses the following ArcGIS for AutoCAD Lisp API functions:_

- [esri_featurelayer_select](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-featurelayer-select.htm) – This function returns an AutoCAD selection set filtered by the specified feature layer.

- [esri_fielddef_add](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-fielddef-add.htm)- This function adds a new field definition to an existing document feature layer.

- [esri_attributes_get](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attributes-get.htm) – This function gets an associated list of the field names and their attribute value.

- [esri_attributes_set](https://doc.arcgis.com/en/arcgis-for-autocad/latest/commands-api/esri-attribute-set.htm) – This function adds or modifies feature attributes on an entity of a feature layer.
