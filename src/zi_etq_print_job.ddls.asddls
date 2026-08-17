@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Trabajos de impresión'

define root view entity ZI_ETQ_PRINT_JOB
  as select from ztetq_print_job
{
  key job_id                  as JobId,

      material                as Material,
      plant                   as Plant,
      batch                   as Batch,

      label_profile           as LabelProfile,

      requested_label_count   as RequestedLabelCount,

      quantity_per_package    as QuantityPerPackage,
      quantity_unit           as QuantityUnit,

      package_count           as PackageCount,
      copies_per_label        as CopiesPerLabel,

      print_status            as PrintStatus,

      @Semantics.user.createdBy: true
      created_by              as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at              as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by   as LocalLastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at   as LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at         as LastChangedAt
}
