#Requires Base Page and adding required gem to access in require statement
require_relative './base_page'
require 'selenium-webdriver'
require 'watir'

#Search Page is Derived Class from Base Page
class SearchPage < BasePage

  include PageObject
  include PageObject::PageFactory
  span(:product_name, class: %w(a-size-base-plus a-color-base a-text-normal))
  span(:product_span, class: /a-declarative/)
  # span(:page_title, id: /productTitle/)
  # span(:add_to_cart, id: /submit.add-to-cart/)
  div(:product_link, xpath: "//div[@class ='product-details']/a")
  button(:add_to_cart, xpath: "//button[contains(text(), 'Add To Cart')]")

end