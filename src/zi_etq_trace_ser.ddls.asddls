@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Series trazabilidad'

define root view entity ZI_ETQ_TRACE_SER
  as select from ztetq_trace_ser
{
  key serial_number          as SerialNumber,

      job_id                 as JobId,

      material               as Material,
      plant                  as Plant,
      batch                  as Batch,
      gtin                   as GTIN,
      expiration_date        as ExpirationDate,

      trace_status           as TraceStatus,

      printed_by             as PrintedBy,
      printed_at             as PrintedAt,

      verified_by            as VerifiedBy,
      verified_at            as VerifiedAt,

      reprint_count          as ReprintCount,

      @Semantics.user.createdBy: true
      created_by             as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at             as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by  as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at  as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at        as LastChangedAt
}
