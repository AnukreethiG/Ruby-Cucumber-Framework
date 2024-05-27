require_relative './base_page'

class MessagePage < BasePage
  include PageObject
  include PageObject::PageFactory

  span(:message, class: %w(a-size-medium-plus a-color-base sw-atc-text a-text-bold))
end