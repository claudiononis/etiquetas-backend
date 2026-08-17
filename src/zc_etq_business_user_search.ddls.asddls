@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Consulta usuarios SAP'
@Metadata.allowExtensions: true

define view entity ZC_ETQ_BUSINESS_USER_SEARCH
  as select from ZI_ETQ_BUSINESS_USER_SEARCH
{
  key UserId,
      BusinessPartner,
      FirstName,
      LastName,
      PersonFullName
}
