@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Acceso usuarios'

define root view entity ZI_ETQ_USER_ACCESS
  as select from ztetq_usr_acc
{
  key user_id               as UserId,

      print_center          as PrintCenter,
      warehouse             as Warehouse,
      quality_control       as QualityControl,
      traceability          as Traceability,
      is_admin              as IsAdmin,
      active                as Active,

      created_by            as CreatedBy,
      created_at            as CreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt
}
