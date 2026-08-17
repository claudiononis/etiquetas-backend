@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Búsqueda usuarios SAP'

define view entity ZI_ETQ_BUSINESS_USER_SEARCH
  as select from I_BusinessUserBasic
{
  key UserID          as UserId,
      BusinessPartner as BusinessPartner,
      FirstName       as FirstName,
      LastName        as LastName,
      PersonFullName  as PersonFullName
}
