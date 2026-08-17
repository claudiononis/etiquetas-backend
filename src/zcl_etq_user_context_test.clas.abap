CLASS zcl_etq_user_context_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS ZCL_ETQ_USER_CONTEXT_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA(lv_technical_user) =
      cl_abap_context_info=>get_user_technical_name( ).

    out->write( '=== CONTEXTO USUARIO ETIQUETAS ===' ).

    out->write(
      |Technical user: { lv_technical_user }|
    ).

    out->write(
      |sy-uname: { sy-uname }|
    ).

    out->write(
      |sy-langu: { sy-langu }|
    ).

    out->write( '=== FIN ===' ).

  ENDMETHOD.
ENDCLASS.
