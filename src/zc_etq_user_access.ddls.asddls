@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Mantenimiento accesos'
@Metadata.allowExtensions: true

define root view entity ZC_ETQ_USER_ACCESS
  provider contract transactional_query
  as projection on ZI_ETQ_USER_ACCESS
{
  key UserId,

      PrintCenter,
      Warehouse,
      QualityControl,
      Traceability,
      IsAdmin,
      Active,

      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
