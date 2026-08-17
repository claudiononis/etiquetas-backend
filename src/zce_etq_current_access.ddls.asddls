@EndUserText.label: 'Etiquetas - Acceso actual calculado'
@ObjectModel.query.implementedBy:
  'ABAP:ZCL_ETQ_CURRENT_ACCESS_QP'

define custom entity ZCE_ETQ_CURRENT_ACCESS
{
  key UserId         : abap.char( 12 );

      PrintCenter    : abap_boolean;
      Warehouse      : abap_boolean;
      QualityControl : abap_boolean;
      Traceability   : abap_boolean;
      IsAdmin        : abap_boolean;
      CanAdminister  : abap_boolean;
      Active         : abap_boolean;
}
