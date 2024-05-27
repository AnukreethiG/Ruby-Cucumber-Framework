require_relative './base_page'

class ProductPage < BasePage
  include PageObject
  include PageObject::PageFactory
  p(:message, class: /text-center/)
  div(:product_price, class: /PriceWithoutCustomization tierPricePrice bold/)
  h1(:product_name, class: /product-name/)
end