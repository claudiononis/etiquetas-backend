@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Gestión trabajos impresión'
@Metadata.allowExtensions: true

define root view entity ZC_ETQ_PRINT_JOB
  provider contract transactional_query
  as projection on ZI_ETQ_PRINT_JOB
{
  key JobId,

      Material,
      Plant,
      Batch,

      LabelProfile,

      RequestedLabelCount,
      QuantityPerPackage,
      QuantityUnit,
      PackageCount,
      CopiesPerLabel,

      PrintStatus,

      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
