CLASS zcl_etq_current_access_qp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.



CLASS ZCL_ETQ_CURRENT_ACCESS_QP IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    TYPES:
      BEGIN OF ty_access,
        UserId          TYPE syuname,
        PrintCenter     TYPE abap_boolean,
        Warehouse       TYPE abap_boolean,
        QualityControl  TYPE abap_boolean,
        Traceability    TYPE abap_boolean,
        IsAdmin         TYPE abap_boolean,
        CanAdminister   TYPE abap_boolean,
        Active          TYPE abap_boolean,
      END OF ty_access.

    DATA:
      ls_result TYPE ty_access,
      lt_result TYPE STANDARD TABLE OF ty_access.

    DATA(lv_user) =
      cl_abap_context_info=>get_user_technical_name( ).

    ls_result-UserId = lv_user.

    "-------------------------------------------------------
    " Accesos internos configurados en la tabla de la app
    "-------------------------------------------------------
    SELECT SINGLE
      print_center,
      warehouse,
      quality_control,
      traceability,
      is_admin,
      active
      FROM ztetq_usr_acc
      WHERE user_id = @lv_user
        AND active  = @abap_true
      INTO @DATA(ls_access).

    IF sy-subrc = 0.

      ls_result-PrintCenter =
        ls_access-print_center.

      ls_result-Warehouse =
        ls_access-warehouse.

      ls_result-QualityControl =
        ls_access-quality_control.

      ls_result-Traceability =
        ls_access-traceability.

      ls_result-IsAdmin =
        ls_access-is_admin.

      ls_result-Active =
        ls_access-active.

    ENDIF.


    "-------------------------------------------------------
    " Super Administrador por rol SAP
    "-------------------------------------------------------
    AUTHORITY-CHECK OBJECT 'Z_ETQ_ADM'
      ID 'ACTVT' FIELD '02'.

    IF sy-subrc = 0.

      ls_result-CanAdminister = abap_true.

      "Aunque todavía no exista en ZTETQ_USR_ACC,
      "el SuperAdmin puede ingresar a Administración
      ls_result-Active = abap_true.

    ELSEIF ls_result-IsAdmin = abap_true.

      ls_result-CanAdminister = abap_true.

    ENDIF.


    "-------------------------------------------------------
    " Resultado lógico completo
    "-------------------------------------------------------
    APPEND ls_result TO lt_result.


    "-------------------------------------------------------
    " COUNT solicitado por OData/Fiori
    "-------------------------------------------------------
    IF io_request->is_total_numb_of_rec_requested( ).

      io_response->set_total_number_of_records(
        lines( lt_result )
      ).

    ENDIF.


    "-------------------------------------------------------
    " DATA + PAGING solicitado por OData/Fiori
    "-------------------------------------------------------
    IF io_request->is_data_requested( ).

      DATA(lo_paging) =
        io_request->get_paging( ).

      DATA(lv_offset) =
        lo_paging->get_offset( ).

      DATA(lv_page_size) =
        lo_paging->get_page_size( ).


      "Solo existe una fila.
      "Si el cliente pidió saltarla, devolvemos vacío.
      IF lv_offset > 0.

        CLEAR lt_result.

      ELSEIF lv_page_size = 0.

        CLEAR lt_result.

      ENDIF.


      io_response->set_data(
        lt_result
      ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
