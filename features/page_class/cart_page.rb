require_relative './base_page'

class CartPage < BasePage
  include PageObject
  include PageObject::PageFactory

  a(:remove_all_item, id: /removeAllCartItems/)
  div(:total_amount, id: /dynamic-order-total/)

end