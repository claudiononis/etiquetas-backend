CLASS zcl_etq_access_bootstrap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS ZCL_ETQ_ACCESS_BOOTSTRAP IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  DATA(lv_user) =
    cl_abap_context_info=>get_user_technical_name( ).

  GET TIME STAMP FIELD DATA(lv_timestamp).

  SELECT SINGLE user_id
    FROM ztetq_usr_acc
    WHERE user_id = @lv_user
    INTO @DATA(lv_existing_user).

  IF sy-subrc = 0.
    out->write(
      |El usuario { lv_user } ya existe en ZTETQ_USR_ACC|
    ).
    RETURN.
  ENDIF.

  DATA(ls_access) = VALUE ztetq_usr_acc(
    user_id               = lv_user
    print_center          = abap_true
    warehouse             = abap_true
    quality_control       = abap_true
    traceability          = abap_true
    is_admin              = abap_true
    active                = abap_true

    created_by            = lv_user
    created_at            = lv_timestamp
    local_last_changed_by = lv_user
    local_last_changed_at = lv_timestamp
    last_changed_at       = lv_timestamp
  ).

  INSERT ztetq_usr_acc FROM @ls_access.

  IF sy-subrc = 0.
    out->write(
      |Administrador inicial creado: { lv_user }|
    ).
  ELSE.
    out->write(
      |Error al crear administrador inicial { lv_user }|
    ).
  ENDIF.

ENDMETHOD.
ENDCLASS.
