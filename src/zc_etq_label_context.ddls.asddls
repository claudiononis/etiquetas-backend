@EndUserText.label: 'Etiquetas - Contexto material lote'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_ETQ_LABEL_CONTEXT_QP'

define custom entity ZC_ETQ_LABEL_CONTEXT
{
  key Material               : abap.char(40);
  key Plant                  : abap.char(4);
  key Batch                  : abap.char(10);
  key Market                 : abap.char(10);

      ProductName            : abap.char(40);
      ProductGroup           : abap.char(9);
      GTIN                   : abap.char(18);
      ExpirationDate         : abap.dats;
      ManufactureDate        : abap.dats;
      BatchBySupplier        : abap.char(15);
      ClfnObjectInternalID   : abap.char(18);

      Desc01                 : abap.char(200);
      Desc02                 : abap.char(200);
      Desc03                 : abap.char(200);
      Desc04                 : abap.char(200);
      Desc05                 : abap.char(200);
      Desc06                 : abap.char(200);
      Desc07                 : abap.char(200);
      Desc08                 : abap.char(200);
      Desc09                 : abap.char(200);
      Desc10                 : abap.char(200);
      Desc11                 : abap.char(200);
      Desc12                 : abap.char(200);
      Desc13                 : abap.char(200);
      Desc14                 : abap.char(200);
      Desc15                 : abap.char(200);
      Desc16                 : abap.char(200);
      Desc17                 : abap.char(200);
      Desc18                 : abap.char(200);
      Desc19                 : abap.char(200);
      Desc20                 : abap.char(200);
      Desc21                 : abap.char(200);
      Desc22                 : abap.char(200);
      Desc23                 : abap.char(200);
      Desc24                 : abap.char(200);
      Desc24B                : abap.char(200);
      Desc25                 : abap.char(200);
      Desc26                 : abap.char(200);
      Desc27                 : abap.char(200);
      Desc28                 : abap.char(200);
      Desc29                 : abap.char(200);
      Desc30                 : abap.char(200);
      Desc31                 : abap.char(200);
      Desc32                 : abap.char(200);
      Desc33                 : abap.char(200);
      Desc34                 : abap.char(200);
      Desc35                 : abap.char(200);

      ValidFrom              : abap.dats;
      ApprovedBy             : abap.char(12);

      BultosCharacteristic   : abap.char(40);

      UnrestrictedStock      : abap.dec(23,3);
      QualityStock           : abap.dec(23,3);
      BlockedStock           : abap.dec(23,3);
      StockUnit              : abap.char(3);

      HasMovement261         : abap.char(1);
      HasMovement541         : abap.char(1);

      PurchaseOrder          : abap.char(10);
      Supplier               : abap.char(10);
      SupplierName           : abap.char(80);

      ApprovalDocument       : abap.char(10);
      ApprovalDocumentYear   : abap.numc(4);
      ApprovalMovementType   : abap.char(3);
      ApprovalDate           : abap.dats;
      ApprovalUser           : abap.char(12);

      RejectionDocument      : abap.char(10);
      RejectionDocumentYear  : abap.numc(4);
      RejectionMovementType  : abap.char(3);
      RejectionDate          : abap.dats;
      RejectionUser          : abap.char(12);

      InspectionLot          : abap.char(12);
      HasUsageDecision       : abap.char(1);
      StockPostingCompleted  : abap.char(1);

      UsageDecisionCodeGroup : abap.char(8);
      UsageDecisionCode      : abap.char(4);
      UsageDecisionValuation : abap.char(1);
      UsageDecisionDate      : abap.dats;
      UsageDecisionBy        : abap.char(12);
}
