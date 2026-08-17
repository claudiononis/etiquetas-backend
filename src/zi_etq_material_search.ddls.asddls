@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Etiquetas - Búsqueda de materiales'

define view entity ZI_ETQ_MATERIAL_SEARCH
  as select from I_Product as Product

    inner join I_ProductText as ProductText
      on ProductText.Product = Product.Product

{
  key Product.Product              as Material,
  key ProductText.Language         as Language,

      Product.ProductOldID         as MaterialOldId,
      ProductText.ProductName      as ProductName,
      Product.ProductGroup         as ProductGroup,
      Product.BaseUnit             as BaseUnit,
      Product.ProductStandardID    as ProductStandardId,
      Product.IndustryStandardName as IndustryStandardName
}
