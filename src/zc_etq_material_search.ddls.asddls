@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Consulta de materiales'
@Metadata.allowExtensions: true

define view entity ZC_ETQ_MATERIAL_SEARCH
  as select from ZI_ETQ_MATERIAL_SEARCH
{
  key Material,
  key Language,

      MaterialOldId,
      ProductName,
      ProductGroup,
      BaseUnit,
      ProductStandardId,
      IndustryStandardName
}
