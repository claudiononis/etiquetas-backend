@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Búsqueda de lotes'

define view entity ZI_ETQ_BATCH_SEARCH
  as select from I_Batch
{
  key Material,
  key Plant,
  key Batch,

      BatchBySupplier,
      ManufactureDate,
      ShelfLifeExpirationDate,
      ClfnObjectInternalID
}
