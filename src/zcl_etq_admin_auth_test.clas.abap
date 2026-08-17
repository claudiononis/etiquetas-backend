CLASS zcl_etq_admin_auth_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.



CLASS ZCL_ETQ_ADMIN_AUTH_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA(lv_user) =
      cl_abap_context_info=>get_user_technical_name( ).

    out->write( |Usuario: { lv_user }| ).

    AUTHORITY-CHECK OBJECT 'Z_ETQ_ADM'
      ID 'ACTVT' FIELD '02'.

    IF sy-subrc = 0.
      out->write(
        'OK - Usuario autorizado como Super Administrador'
      ).
    ELSE.
      out->write(
        |NO autorizado. SY-SUBRC = { sy-subrc }|
      ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
