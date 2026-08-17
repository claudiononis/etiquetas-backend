CLASS zcl_etq_label_context_qp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

ENDCLASS.



CLASS ZCL_ETQ_LABEL_CONTEXT_QP IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    TYPES:
      BEGIN OF ty_result,
        material                 TYPE c LENGTH 40,
        plant                    TYPE c LENGTH 4,
        batch                    TYPE c LENGTH 10,
        market                   TYPE c LENGTH 10,

        productname              TYPE c LENGTH 40,
        productgroup             TYPE c LENGTH 9,
        gtin                     TYPE c LENGTH 18,
        expirationdate           TYPE d,
        manufacturedate          TYPE d,
        batchbysupplier          TYPE c LENGTH 15,
        clfnobjectinternalid     TYPE c LENGTH 18,

        desc01                   TYPE c LENGTH 200,
        desc02                   TYPE c LENGTH 200,
        desc03                   TYPE c LENGTH 200,
        desc04                   TYPE c LENGTH 200,
        desc05                   TYPE c LENGTH 200,
        desc06                   TYPE c LENGTH 200,
        desc07                   TYPE c LENGTH 200,
        desc08                   TYPE c LENGTH 200,
        desc09                   TYPE c LENGTH 200,
        desc10                   TYPE c LENGTH 200,
        desc11                   TYPE c LENGTH 200,
        desc12                   TYPE c LENGTH 200,
        desc13                   TYPE c LENGTH 200,
        desc14                   TYPE c LENGTH 200,
        desc15                   TYPE c LENGTH 200,
        desc16                   TYPE c LENGTH 200,
        desc17                   TYPE c LENGTH 200,
        desc18                   TYPE c LENGTH 200,
        desc19                   TYPE c LENGTH 200,
        desc20                   TYPE c LENGTH 200,
        desc21                   TYPE c LENGTH 200,
        desc22                   TYPE c LENGTH 200,
        desc23                   TYPE c LENGTH 200,
        desc24                   TYPE c LENGTH 200,
        desc24b                  TYPE c LENGTH 200,
        desc25                   TYPE c LENGTH 200,
        desc26                   TYPE c LENGTH 200,
        desc27                   TYPE c LENGTH 200,
        desc28                   TYPE c LENGTH 200,
        desc29                   TYPE c LENGTH 200,
        desc30                   TYPE c LENGTH 200,
        desc31                   TYPE c LENGTH 200,
        desc32                   TYPE c LENGTH 200,
        desc33                   TYPE c LENGTH 200,
        desc34                   TYPE c LENGTH 200,
        desc35                   TYPE c LENGTH 200,

        validfrom                TYPE d,
        approvedby               TYPE c LENGTH 12,

        bultoscharacteristic     TYPE c LENGTH 40,

        unrestrictedstock        TYPE p LENGTH 12 DECIMALS 3,
        qualitystock             TYPE p LENGTH 12 DECIMALS 3,
        blockedstock             TYPE p LENGTH 12 DECIMALS 3,
        stockunit                TYPE c LENGTH 3,

        hasmovement261           TYPE c LENGTH 1,
        hasmovement541           TYPE c LENGTH 1,

        purchaseorder            TYPE c LENGTH 10,
        supplier                 TYPE c LENGTH 10,
        suppliername             TYPE c LENGTH 80,

        approvaldocument         TYPE c LENGTH 10,
        approvaldocumentyear     TYPE n LENGTH 4,
        approvalmovementtype     TYPE c LENGTH 3,
        approvaldate             TYPE d,
        approvaluser             TYPE c LENGTH 12,

        rejectiondocument        TYPE c LENGTH 10,
        rejectiondocumentyear    TYPE n LENGTH 4,
        rejectionmovementtype    TYPE c LENGTH 3,
        rejectiondate            TYPE d,
        rejectionuser            TYPE c LENGTH 12,

        inspectionlot            TYPE c LENGTH 12,
        hasusagedecision         TYPE c LENGTH 1,
        stockpostingcompleted    TYPE c LENGTH 1,

        usagedecisioncodegroup   TYPE c LENGTH 8,
        usagedecisioncode        TYPE c LENGTH 4,
        usagedecisionvaluation   TYPE c LENGTH 1,
        usagedecisiondate        TYPE d,
        usagedecisionby          TYPE c LENGTH 12,

      END OF ty_result.


    DATA:
      lt_result       TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY,
      ls_result       TYPE ty_result,

      lv_material     TYPE c LENGTH 40,
      lv_plant        TYPE c LENGTH 4,
      lv_batch        TYPE c LENGTH 10,
      lv_market       TYPE c LENGTH 10,

      lv_bultos_value TYPE c LENGTH 40.


    "------------------------------------------------------------
    " 1. Leer filtros recibidos por OData
    "------------------------------------------------------------
    TRY.

        DATA(lt_ranges) =
          io_request->get_filter( )->get_as_ranges( ).

      CATCH cx_rap_query_filter_no_range.

        IF io_request->is_data_requested( ).
          io_response->set_data( lt_result ).
        ENDIF.

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( 0 ).
        ENDIF.

        RETURN.

    ENDTRY.


    LOOP AT lt_ranges INTO DATA(ls_range).

      CASE to_upper( ls_range-name ).

        WHEN 'MATERIAL'.

          READ TABLE ls_range-range
            INDEX 1
            INTO DATA(ls_material_range).

          IF sy-subrc = 0
             AND ls_material_range-sign = 'I'
             AND ls_material_range-option = 'EQ'.

            lv_material = ls_material_range-low.

          ENDIF.


        WHEN 'PLANT'.

          READ TABLE ls_range-range
            INDEX 1
            INTO DATA(ls_plant_range).

          IF sy-subrc = 0
             AND ls_plant_range-sign = 'I'
             AND ls_plant_range-option = 'EQ'.

            lv_plant = ls_plant_range-low.

          ENDIF.


        WHEN 'BATCH'.

          READ TABLE ls_range-range
            INDEX 1
            INTO DATA(ls_batch_range).

          IF sy-subrc = 0
             AND ls_batch_range-sign = 'I'
             AND ls_batch_range-option = 'EQ'.

            lv_batch = ls_batch_range-low.

          ENDIF.


        WHEN 'MARKET'.

          READ TABLE ls_range-range
            INDEX 1
            INTO DATA(ls_market_range).

          IF sy-subrc = 0
             AND ls_market_range-sign = 'I'
             AND ls_market_range-option = 'EQ'.

            lv_market =
              to_upper( ls_market_range-low ).

          ENDIF.

      ENDCASE.

    ENDLOOP.


    "------------------------------------------------------------
    " 2. Material + Plant + Batch obligatorios
    "
    " Market NO es obligatorio:
    " otros procesos reutilizan LabelContext sin Nacional/COMEX.
    "------------------------------------------------------------
    IF lv_material IS INITIAL
       OR lv_plant IS INITIAL
       OR lv_batch IS INITIAL.

      IF io_request->is_data_requested( ).
        io_response->set_data( lt_result ).
      ENDIF.

      IF io_request->is_total_numb_of_rec_requested( ).
        io_response->set_total_number_of_records( 0 ).
      ENDIF.

      RETURN.

    ENDIF.


    "------------------------------------------------------------
    " 3. Producto
    "------------------------------------------------------------
    SELECT SINGLE
           ProductStandardID,
           ProductGroup
      FROM I_Product
      WHERE Product = @lv_material
      INTO @DATA(ls_product).

    IF sy-subrc <> 0.

      IF io_request->is_data_requested( ).
        io_response->set_data( lt_result ).
      ENDIF.

      IF io_request->is_total_numb_of_rec_requested( ).
        io_response->set_total_number_of_records( 0 ).
      ENDIF.

      RETURN.

    ENDIF.


    "------------------------------------------------------------
    " 4. Descripción
    "------------------------------------------------------------
    SELECT SINGLE
           ProductName
      FROM I_ProductText
      WHERE Product  = @lv_material
        AND Language = @sy-langu
      INTO @DATA(lv_product_name).


    "------------------------------------------------------------
    " 5. Lote
    "------------------------------------------------------------
    SELECT SINGLE
           BatchBySupplier,
           ManufactureDate,
           ShelfLifeExpirationDate,
           ClfnObjectInternalID
      FROM I_Batch
      WHERE Material = @lv_material
        AND Plant    = @lv_plant
        AND Batch    = @lv_batch
      INTO @DATA(ls_batch).

    IF sy-subrc <> 0.

      IF io_request->is_data_requested( ).
        io_response->set_data( lt_result ).
      ENDIF.

      IF io_request->is_total_numb_of_rec_requested( ).
        io_response->set_total_number_of_records( 0 ).
      ENDIF.

      RETURN.

    ENDIF.


    "------------------------------------------------------------
    " 6. Configuración Hospitalaria / COMEX
    "
    " NATIONAL -> ZETQ_HOS
    " COMEX    -> ZETQ_HOS_COMEX
    "
    " Si Market no viene informado, esta parte se omite.
    "------------------------------------------------------------
    CASE lv_market.

      WHEN 'NATIONAL'.

        SELECT SINGLE *
          FROM zetq_hos
          WHERE material = @lv_material
          INTO @DATA(ls_hos).

        IF sy-subrc = 0.

          ls_result-desc01 = ls_hos-desc_01.
          ls_result-desc02 = ls_hos-desc_02.
          ls_result-desc03 = ls_hos-desc_03.
          ls_result-desc04 = ls_hos-desc_04.
          ls_result-desc05 = ls_hos-desc_05.
          ls_result-desc06 = ls_hos-desc_06.
          ls_result-desc07 = ls_hos-desc_07.
          ls_result-desc08 = ls_hos-desc_08.
          ls_result-desc09 = ls_hos-desc_09.
          ls_result-desc10 = ls_hos-desc_10.
          ls_result-desc11 = ls_hos-desc_11.
          ls_result-desc12 = ls_hos-desc_12.
          ls_result-desc13 = ls_hos-desc_13.
          ls_result-desc14 = ls_hos-desc_14.
          ls_result-desc15 = ls_hos-desc_15.
          ls_result-desc16 = ls_hos-desc_16.
          ls_result-desc17 = ls_hos-desc_17.
          ls_result-desc18 = ls_hos-desc_18.
          ls_result-desc19 = ls_hos-desc_19.
          ls_result-desc20 = ls_hos-desc_20.
          ls_result-desc21 = ls_hos-desc_21.
          ls_result-desc22 = ls_hos-desc_22.
          ls_result-desc23 = ls_hos-desc_23.
          ls_result-desc24 = ls_hos-desc_24.

          CLEAR ls_result-desc24b.

          ls_result-desc25 = ls_hos-desc_25.
          ls_result-desc26 = ls_hos-desc_26.
          ls_result-desc27 = ls_hos-desc_27.
          ls_result-desc28 = ls_hos-desc_28.
          ls_result-desc29 = ls_hos-desc_29.
          ls_result-desc30 = ls_hos-desc_30.
          ls_result-desc31 = ls_hos-desc_31.
          ls_result-desc32 = ls_hos-desc_32.
          ls_result-desc33 = ls_hos-desc_33.
          ls_result-desc34 = ls_hos-desc_34.
          ls_result-desc35 = ls_hos-desc_35.

          ls_result-validfrom =
            ls_hos-valid_from.

          ls_result-approvedby =
            ls_hos-approved_by.

        ENDIF.


      WHEN 'COMEX'.

        SELECT SINGLE *
          FROM zetq_hos_comex
          WHERE material = @lv_material
          INTO @DATA(ls_hos_comex).

        IF sy-subrc = 0.

          ls_result-desc01 = ls_hos_comex-desc_01.
          ls_result-desc02 = ls_hos_comex-desc_02.
          ls_result-desc03 = ls_hos_comex-desc_03.
          ls_result-desc04 = ls_hos_comex-desc_04.
          ls_result-desc05 = ls_hos_comex-desc_05.
          ls_result-desc06 = ls_hos_comex-desc_06.
          ls_result-desc07 = ls_hos_comex-desc_07.
          ls_result-desc08 = ls_hos_comex-desc_08.
          ls_result-desc09 = ls_hos_comex-desc_09.
          ls_result-desc10 = ls_hos_comex-desc_10.
          ls_result-desc11 = ls_hos_comex-desc_11.
          ls_result-desc12 = ls_hos_comex-desc_12.
          ls_result-desc13 = ls_hos_comex-desc_13.
          ls_result-desc14 = ls_hos_comex-desc_14.
          ls_result-desc15 = ls_hos_comex-desc_15.
          ls_result-desc16 = ls_hos_comex-desc_16.
          ls_result-desc17 = ls_hos_comex-desc_17.
          ls_result-desc18 = ls_hos_comex-desc_18.
          ls_result-desc19 = ls_hos_comex-desc_19.
          ls_result-desc20 = ls_hos_comex-desc_20.
          ls_result-desc21 = ls_hos_comex-desc_21.
          ls_result-desc22 = ls_hos_comex-desc_22.
          ls_result-desc23 = ls_hos_comex-desc_23.
          ls_result-desc24 = ls_hos_comex-desc_24.
          ls_result-desc24b = ls_hos_comex-desc_24b.
          ls_result-desc25 = ls_hos_comex-desc_25.
          ls_result-desc26 = ls_hos_comex-desc_26.
          ls_result-desc27 = ls_hos_comex-desc_27.
          ls_result-desc28 = ls_hos_comex-desc_28.
          ls_result-desc29 = ls_hos_comex-desc_29.
          ls_result-desc30 = ls_hos_comex-desc_30.
          ls_result-desc31 = ls_hos_comex-desc_31.
          ls_result-desc32 = ls_hos_comex-desc_32.
          ls_result-desc33 = ls_hos_comex-desc_33.
          ls_result-desc34 = ls_hos_comex-desc_34.
          ls_result-desc35 = ls_hos_comex-desc_35.

          ls_result-validfrom =
            ls_hos_comex-valid_from.

          ls_result-approvedby =
            ls_hos_comex-approved_by.

        ENDIF.

    ENDCASE.


    "------------------------------------------------------------
    " 7. Característica BULTOS
    "------------------------------------------------------------
    SELECT SINGLE
           CharcInternalID
      FROM I_ClfnCharacteristicForKeyDate(
             P_KeyDate = @sy-datum )
      WHERE Characteristic = 'BULTOS'
      INTO @DATA(lv_bultos_charc_id).


    IF lv_bultos_charc_id IS NOT INITIAL
       AND ls_batch-ClfnObjectInternalID IS NOT INITIAL.

      SELECT SINGLE
             CharcValue,
             CharcFromNumericValue,
             CharcFromDecimalValue
        FROM I_ClfnObjectCharcValForKeyDate(
               P_KeyDate = @sy-datum )
        WHERE ClfnObjectInternalID = @ls_batch-ClfnObjectInternalID
          AND CharcInternalID      = @lv_bultos_charc_id
        INTO @DATA(ls_bultos).

      IF sy-subrc = 0.

        IF ls_bultos-CharcValue IS NOT INITIAL.

          lv_bultos_value =
            ls_bultos-CharcValue.

        ELSEIF ls_bultos-CharcFromDecimalValue IS NOT INITIAL.

          lv_bultos_value =
            |{ ls_bultos-CharcFromDecimalValue }|.

        ELSEIF ls_bultos-CharcFromNumericValue IS NOT INITIAL.

          lv_bultos_value =
            |{ ls_bultos-CharcFromNumericValue }|.

        ENDIF.

      ENDIF.

    ENDIF.


    "------------------------------------------------------------
    " 8. Stocks
    "------------------------------------------------------------
    SELECT
      SUM( MatlWrhsStkQtyInMatlBaseUnit )
      FROM I_MaterialStock_2
      WHERE Material                  = @lv_material
        AND Plant                     = @lv_plant
        AND Batch                     = @lv_batch
        AND InventoryStockType        = '01'
        AND InventorySpecialStockType = ''
      INTO @DATA(lv_unrestricted_stock).


    SELECT
      SUM( MatlWrhsStkQtyInMatlBaseUnit )
      FROM I_MaterialStock_2
      WHERE Material                  = @lv_material
        AND Plant                     = @lv_plant
        AND Batch                     = @lv_batch
        AND InventoryStockType        = '02'
        AND InventorySpecialStockType = ''
      INTO @DATA(lv_quality_stock).


    SELECT
      SUM( MatlWrhsStkQtyInMatlBaseUnit )
      FROM I_MaterialStock_2
      WHERE Material                  = @lv_material
        AND Plant                     = @lv_plant
        AND Batch                     = @lv_batch
        AND InventoryStockType        = '07'
        AND InventorySpecialStockType = ''
      INTO @DATA(lv_blocked_stock).


    SELECT SINGLE
           MaterialBaseUnit
      FROM I_MaterialStock_2
      WHERE Material                  = @lv_material
        AND Plant                     = @lv_plant
        AND Batch                     = @lv_batch
        AND InventorySpecialStockType = ''
      INTO @DATA(lv_stock_unit).


    "------------------------------------------------------------
    " 9. Evidencia histórica 261
    "------------------------------------------------------------
    SELECT SINGLE
           MaterialDocument
      FROM I_MaterialDocumentItem_2
      WHERE Material          = @lv_material
        AND Plant             = @lv_plant
        AND Batch             = @lv_batch
        AND GoodsMovementType = '261'
      INTO @DATA(lv_document_261).

    IF sy-subrc = 0.
      ls_result-hasmovement261 = 'X'.
    ENDIF.


    "------------------------------------------------------------
    " 10. Evidencia histórica 541
    "------------------------------------------------------------
    SELECT SINGLE
           MaterialDocument
      FROM I_MaterialDocumentItem_2
      WHERE Material          = @lv_material
        AND Plant             = @lv_plant
        AND Batch             = @lv_batch
        AND GoodsMovementType = '541'
      INTO @DATA(lv_document_541).

    IF sy-subrc = 0.
      ls_result-hasmovement541 = 'X'.
    ENDIF.


    "------------------------------------------------------------
    " 11. OC + proveedor
    "
    " Paridad ECC:
    " último movimiento 101 del Material + Plant + Batch
    " que tenga PurchaseOrder informada.
    "------------------------------------------------------------
    SELECT
           MaterialDocumentYear,
           MaterialDocument,
           MaterialDocumentItem,
           PurchaseOrder,
           Supplier
      FROM I_MaterialDocumentItem_2
      WHERE Material          = @lv_material
        AND Plant             = @lv_plant
        AND Batch             = @lv_batch
        AND GoodsMovementType = '101'
        AND PurchaseOrder     <> ''
      ORDER BY MaterialDocumentYear DESCENDING,
               MaterialDocument     DESCENDING,
               MaterialDocumentItem DESCENDING
      INTO TABLE @DATA(lt_receipt_documents)
      UP TO 1 ROWS.


    READ TABLE lt_receipt_documents
      INDEX 1
      INTO DATA(ls_receipt_document).

    IF sy-subrc = 0.

      ls_result-purchaseorder =
        ls_receipt_document-PurchaseOrder.

      ls_result-supplier =
        ls_receipt_document-Supplier.


      IF ls_receipt_document-Supplier IS NOT INITIAL.

        SELECT SINGLE
               OrganizationBPName1
          FROM I_Supplier
          WHERE Supplier =
                @ls_receipt_document-Supplier
          INTO @DATA(lv_supplier_name).

        IF sy-subrc = 0
           AND lv_supplier_name IS NOT INITIAL.

          ls_result-suppliername =
            lv_supplier_name.

        ELSE.

          ls_result-suppliername =
            'N/A'.

        ENDIF.

      ELSE.

        ls_result-suppliername =
          'N/A'.

      ENDIF.

    ELSE.

      CLEAR:
        ls_result-purchaseorder,
        ls_result-supplier.

      ls_result-suppliername =
        'N/A'.

    ENDIF.


    "------------------------------------------------------------
    " 12. Documento de APROBACIÓN
    "
    " Prioridad ECC:
    " 1) último 321
    " 2) si no existe 321, último 350
    "------------------------------------------------------------
    SELECT
           MaterialDocumentYear,
           MaterialDocument,
           GoodsMovementType,
           PostingDate
      FROM I_MaterialDocumentItem_2
      WHERE Material          = @lv_material
        AND Plant             = @lv_plant
        AND Batch             = @lv_batch
        AND GoodsMovementType = '321'
      ORDER BY MaterialDocumentYear DESCENDING,
               MaterialDocument     DESCENDING
      INTO TABLE @DATA(lt_approval_documents)
      UP TO 1 ROWS.

    IF lt_approval_documents IS INITIAL.

      SELECT
             MaterialDocumentYear,
             MaterialDocument,
             GoodsMovementType,
             PostingDate
        FROM I_MaterialDocumentItem_2
        WHERE Material          = @lv_material
          AND Plant             = @lv_plant
          AND Batch             = @lv_batch
          AND GoodsMovementType = '350'
        ORDER BY MaterialDocumentYear DESCENDING,
                 MaterialDocument     DESCENDING
        INTO TABLE @lt_approval_documents
        UP TO 1 ROWS.

    ENDIF.


    READ TABLE lt_approval_documents
      INDEX 1
      INTO DATA(ls_approval_document).

    IF sy-subrc = 0.

      ls_result-approvaldocument =
        ls_approval_document-MaterialDocument.

      ls_result-approvaldocumentyear =
        ls_approval_document-MaterialDocumentYear.

      ls_result-approvalmovementtype =
        ls_approval_document-GoodsMovementType.

      ls_result-approvaldate =
        ls_approval_document-PostingDate.


      SELECT SINGLE
             CreatedByUser
        FROM I_MaterialDocumentHeader_2
        WHERE MaterialDocumentYear =
                @ls_approval_document-MaterialDocumentYear
          AND MaterialDocument =
                @ls_approval_document-MaterialDocument
        INTO @DATA(lv_approval_user).

      IF sy-subrc = 0.
        ls_result-approvaluser = lv_approval_user.
      ENDIF.

    ENDIF.


    "------------------------------------------------------------
    " 13. Documento de RECHAZO
    "------------------------------------------------------------
    SELECT
           MaterialDocumentYear,
           MaterialDocument,
           GoodsMovementType,
           PostingDate
      FROM I_MaterialDocumentItem_2
      WHERE Material = @lv_material
        AND Plant    = @lv_plant
        AND Batch    = @lv_batch
        AND (
             GoodsMovementType = '325'
          OR GoodsMovementType = '350'
          OR GoodsMovementType = '343'
          OR GoodsMovementType = '344'
        )
      ORDER BY MaterialDocumentYear DESCENDING,
               MaterialDocument     DESCENDING
      INTO TABLE @DATA(lt_rejection_documents)
      UP TO 1 ROWS.


    READ TABLE lt_rejection_documents
      INDEX 1
      INTO DATA(ls_rejection_document).

    IF sy-subrc = 0.

      ls_result-rejectiondocument =
        ls_rejection_document-MaterialDocument.

      ls_result-rejectiondocumentyear =
        ls_rejection_document-MaterialDocumentYear.

      ls_result-rejectionmovementtype =
        ls_rejection_document-GoodsMovementType.

      ls_result-rejectiondate =
        ls_rejection_document-PostingDate.


      SELECT SINGLE
             CreatedByUser
        FROM I_MaterialDocumentHeader_2
        WHERE MaterialDocumentYear =
                @ls_rejection_document-MaterialDocumentYear
          AND MaterialDocument =
                @ls_rejection_document-MaterialDocument
        INTO @DATA(lv_rejection_user).

      IF sy-subrc = 0.
        ls_result-rejectionuser = lv_rejection_user.
      ENDIF.

    ENDIF.


    "------------------------------------------------------------
    " 14. QM
    "------------------------------------------------------------
    SELECT
           InspectionLot,
           InspectionLotHasUsageDecision,
           InspLotIsStockPostingCompleted
      FROM I_InspectionLot
      WHERE Material = @lv_material
        AND Plant    = @lv_plant
        AND Batch    = @lv_batch
      INTO TABLE @DATA(lt_inspection_lots)
      UP TO 2 ROWS.


    IF lines( lt_inspection_lots ) = 1.

      READ TABLE lt_inspection_lots
        INDEX 1
        INTO DATA(ls_inspection_lot).

      IF sy-subrc = 0.

        ls_result-inspectionlot =
          ls_inspection_lot-InspectionLot.

        ls_result-hasusagedecision =
          ls_inspection_lot-InspectionLotHasUsageDecision.

        ls_result-stockpostingcompleted =
          ls_inspection_lot-InspLotIsStockPostingCompleted.


        SELECT SINGLE
               InspLotUsageDecisionCodeGroup,
               InspectionLotUsageDecisionCode,
               InspLotUsageDecisionValuation,
               InspectionLotUsageDecidedOn,
               InspectionLotUsageDecidedBy
          FROM I_InspLotUsageDecision
          WHERE InspectionLot =
                @ls_inspection_lot-InspectionLot
          INTO @DATA(ls_usage_decision).

        IF sy-subrc = 0.

          ls_result-usagedecisioncodegroup =
            ls_usage_decision-InspLotUsageDecisionCodeGroup.

          ls_result-usagedecisioncode =
            ls_usage_decision-InspectionLotUsageDecisionCode.

          ls_result-usagedecisionvaluation =
            ls_usage_decision-InspLotUsageDecisionValuation.

          ls_result-usagedecisiondate =
            ls_usage_decision-InspectionLotUsageDecidedOn.

          ls_result-usagedecisionby =
            ls_usage_decision-InspectionLotUsageDecidedBy.

        ENDIF.

      ENDIF.

    ENDIF.


    "------------------------------------------------------------
    " 15. Resultado
    "------------------------------------------------------------
    ls_result-material =
      lv_material.

    ls_result-plant =
      lv_plant.

    ls_result-batch =
      lv_batch.

    ls_result-market =
      lv_market.

    ls_result-productname =
      lv_product_name.

    ls_result-productgroup =
      ls_product-ProductGroup.

    ls_result-gtin =
      ls_product-ProductStandardID.

    ls_result-expirationdate =
      ls_batch-ShelfLifeExpirationDate.

    ls_result-manufacturedate =
      ls_batch-ManufactureDate.

    ls_result-batchbysupplier =
      ls_batch-BatchBySupplier.

    ls_result-clfnobjectinternalid =
      ls_batch-ClfnObjectInternalID.

    ls_result-bultoscharacteristic =
      lv_bultos_value.

    ls_result-unrestrictedstock =
      lv_unrestricted_stock.

    ls_result-qualitystock =
      lv_quality_stock.

    ls_result-blockedstock =
      lv_blocked_stock.

    ls_result-stockunit =
      lv_stock_unit.


    APPEND ls_result TO lt_result.


    "------------------------------------------------------------
    " 16. Respuesta RAP
    "------------------------------------------------------------
    IF io_request->is_data_requested( ).

      io_response->set_data(
        lt_result
      ).

    ENDIF.


    IF io_request->is_total_numb_of_rec_requested( ).

      io_response->set_total_number_of_records(
        lines( lt_result )
      ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
