CLASS lhc_UserAccess DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR UserAccess RESULT result.

ENDCLASS.

CLASS lhc_UserAccess IMPLEMENTATION.

 METHOD get_global_authorizations.

  DATA lv_is_allowed TYPE abap_bool VALUE abap_false.

  " 1. Super Admin SAP
  AUTHORITY-CHECK OBJECT 'Z_ETQ_ADM'
    ID 'ACTVT' FIELD '02'.

  IF sy-subrc = 0.
    lv_is_allowed = abap_true.
  ENDIF.

  " 2. Administrador interno de Etiquetas
  IF lv_is_allowed = abap_false.

    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    SELECT SINGLE is_admin
      FROM ztetq_usr_acc
      WHERE user_id = @lv_user
        AND active  = @abap_true
      INTO @DATA(lv_is_admin).

    IF sy-subrc = 0 AND lv_is_admin = abap_true.
      lv_is_allowed = abap_true.
    ENDIF.

  ENDIF.

  IF requested_authorizations-%create = if_abap_behv=>mk-on.
    result-%create = COND #(
      WHEN lv_is_allowed = abap_true
      THEN if_abap_behv=>auth-allowed
      ELSE if_abap_behv=>auth-unauthorized ).
  ENDIF.

  IF requested_authorizations-%update = if_abap_behv=>mk-on.
    result-%update = COND #(
      WHEN lv_is_allowed = abap_true
      THEN if_abap_behv=>auth-allowed
      ELSE if_abap_behv=>auth-unauthorized ).
  ENDIF.

  IF requested_authorizations-%delete = if_abap_behv=>mk-on.
    result-%delete = COND #(
      WHEN lv_is_allowed = abap_true
      THEN if_abap_behv=>auth-allowed
      ELSE if_abap_behv=>auth-unauthorized ).
  ENDIF.

ENDMETHOD.

ENDCLASS.
