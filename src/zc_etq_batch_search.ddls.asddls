@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Consulta de lotes'
@Metadata.allowExtensions: true

define view entity ZC_ETQ_BATCH_SEARCH
  as select from ZI_ETQ_BATCH_SEARCH
{
  key Material,
  key Plant,
  key Batch,

      BatchBySupplier,
      ManufactureDate,
      ShelfLifeExpirationDate,
      ClfnObjectInternalID
}
