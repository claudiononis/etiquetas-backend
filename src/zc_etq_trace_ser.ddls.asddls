@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Gestión series trazabilidad'
@Metadata.allowExtensions: true

define root view entity ZC_ETQ_TRACE_SER
  provider contract transactional_query
  as projection on ZI_ETQ_TRACE_SER
{
  key SerialNumber,

      JobId,

      Material,
      Plant,
      Batch,
      GTIN,
      ExpirationDate,

      TraceStatus,

      PrintedBy,
      PrintedAt,

      VerifiedBy,
      VerifiedAt,

      ReprintCount,

      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
