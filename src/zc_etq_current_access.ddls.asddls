@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Consulta acceso actual'
@Metadata.allowExtensions: true

define view entity ZC_ETQ_CURRENT_ACCESS
  as select from ZI_ETQ_CURRENT_ACCESS
{
  key UserId,

      PrintCenter,
      Warehouse,
      QualityControl,
      Traceability,
      IsAdmin,
      Active
}
