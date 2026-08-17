@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Configuración Nacional'
@Metadata.allowExtensions: true

define root view entity ZC_ETQ_HOS
  provider contract transactional_query
  as projection on ZI_ETQ_HOS
{
  key Material,

      Desc01,
      Desc02,
      Desc03,
      Desc04,
      Desc05,
      Desc06,
      Desc07,
      Desc08,
      Desc09,
      Desc10,
      Desc11,
      Desc12,
      Desc13,
      Desc14,
      Desc15,
      Desc16,
      Desc17,
      Desc18,
      Desc19,
      Desc20,
      Desc21,
      Desc22,
      Desc23,
      Desc24,
      Desc25,
      Desc26,
      Desc27,
      Desc28,
      Desc29,
      Desc30,
      Desc31,
      Desc32,
      Desc33,
      Desc34,
      Desc35,

      ValidFrom,
      ApprovedBy,

      CreatedBy,
      CreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt
}
