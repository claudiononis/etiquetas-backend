@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Configuración Nacional'
@Metadata.allowExtensions: true

define root view entity ZI_ETQ_HOS
  as select from zetq_hos
{
  key material                as Material,

      desc_01                 as Desc01,
      desc_02                 as Desc02,
      desc_03                 as Desc03,
      desc_04                 as Desc04,
      desc_05                 as Desc05,
      desc_06                 as Desc06,
      desc_07                 as Desc07,
      desc_08                 as Desc08,
      desc_09                 as Desc09,
      desc_10                 as Desc10,
      desc_11                 as Desc11,
      desc_12                 as Desc12,
      desc_13                 as Desc13,
      desc_14                 as Desc14,
      desc_15                 as Desc15,
      desc_16                 as Desc16,
      desc_17                 as Desc17,
      desc_18                 as Desc18,
      desc_19                 as Desc19,
      desc_20                 as Desc20,
      desc_21                 as Desc21,
      desc_22                 as Desc22,
      desc_23                 as Desc23,
      desc_24                 as Desc24,
      desc_25                 as Desc25,
      desc_26                 as Desc26,
      desc_27                 as Desc27,
      desc_28                 as Desc28,
      desc_29                 as Desc29,
      desc_30                 as Desc30,
      desc_31                 as Desc31,
      desc_32                 as Desc32,
      desc_33                 as Desc33,
      desc_34                 as Desc34,
      desc_35                 as Desc35,

      valid_from              as ValidFrom,
      approved_by             as ApprovedBy,

      created_by              as CreatedBy,
      created_at              as CreatedAt,
      local_last_changed_by   as LocalLastChangedBy,
      local_last_changed_at   as LocalLastChangedAt,
      last_changed_at         as LastChangedAt
}
