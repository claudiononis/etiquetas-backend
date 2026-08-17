@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Acceso usuario actual'

define view entity ZI_ETQ_CURRENT_ACCESS
  as select from ztetq_usr_acc
{
  key user_id          as UserId,

      print_center     as PrintCenter,
      warehouse        as Warehouse,
      quality_control  as QualityControl,
      traceability     as Traceability,
      is_admin         as IsAdmin,
      active           as Active
}
where
      user_id = $session.user
  and active  = 'X'
