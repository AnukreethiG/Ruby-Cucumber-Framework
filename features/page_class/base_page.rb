require 'selenium-webdriver'
require 'watir'
require 'rubygems'
require 'nokogiri'
require 'time'
require 'fileutils'
require 'spreadsheet'

#BasePage is Super class of this frame work
class BasePage
  include PageObject
  include PageObject::PageFactory

  text_field(:product_name, id: /twotabsearchtextbox/, class: 'nav-input nav-progressive-attribute', type: 'text')
  span(:cart_icon, class: %w(nav-cart-icon))
  span(:language_dropdown, class: 'icp-nav-flag icp-nav-flag-in icp-nav-flag-lop')
  div(:list_of_language, class: 'a-row a-spacing-mini')
  radio_button(:language, name: /lop/, type: 'radio')
  text_field(:product_name_ey_merch, id: /searchTextBox/)
  button(:consent_acceptance, id: /truste-consent-button/)
  span(:cart_icon, class: 'icon-shopping-cart')

  def set_text_field(field, data)
    wait_for_element(field)
    begin
      #send is a inbuilt method in ruby to input data to a field
      self.send("#{field}=", data)
    rescue Selenium::Webdriver::Error::UnexpectedAlertOpenError
      @browser.alert.ok
    end
  end

  def wait_for_element(element_or_name, option = {})
    sleep(5)
    element = resolve_element element_or_name
    timeout = option.delete(:timeout) || 45
    delay = option.delete(:delay) || 0.5
    message = option.delete(:message) || "Locating element '#{element_or_name}'"
    raise "Invalid Options: #{option}" unless option.empty?
    sleep(5)
  end

  def resolve_element(element, plural = false)
    if element.is_a?(String) || element.is_a?(Symbol)
      send("#{element}_element#{plural ? 's' : ''}")
    else
      element
    end
  end

  def get_text(element)
    wait_for_element(element)
    text = send("#{element}").text
    text.to_s
  end

  def get_value(element)
    wait_for_element(element)
    text = send("#{element}").value
    text.to_s
  end

  def click_element(elements)
    element = resolve_element(elements)
    element.click
  end

  def take_screenshot
    path = "features/support/screenshot"
    FileUtils.mkdir_p(path)
    page_title = @browser.driver.find_element(tag_name: 'body').attribute('id')
    timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
    file_name = "#{path}/#{timestamp}_#{page_title}.png"
    @browser.driver.save_screenshot(file_name)
  end

  def generate_report(test_case, product, product_name, price)
    path = "features/support/report"
    FileUtils.mkdir_p(path)
    timestamp = Time.now.strftime('%Y%m%d')
    file_name = "#{path}/Report_#{timestamp}.xls"
    file_exist = File.exist?(file_name)
    if file_exist
      book = Spreadsheet.open(file_name)
      sheet = book.worksheet(0)
      row = sheet.row_count
    else
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet

      sheet[0, 0] = 'Test_Case'
      sheet[0, 1] = 'Product'
      sheet[0, 2] = 'Product_Name'
      sheet[0, 3] = 'Price'
      row = 1
    end
    sheet[row, 0] = test_case
    sheet[row, 1] = product
    sheet[row, 2] = product_name
    sheet[row, 3] = price
    book.write(file_name)
  end
end