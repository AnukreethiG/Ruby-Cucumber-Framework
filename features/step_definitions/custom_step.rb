# require_relative '../page_class/base_page'
# require_relative '../page_class/search_page'
# require_relative '../page_class/message_page'
# require 'open-uri'
# require 'nokogiri'
# require 'selenium-webdriver'
require 'watir'

Given(/^I launch (.*) webpage$/)do |site|
  #Opening a browser using Watir Gem - Goto method
  case site
  when "Amazon"
  @browser.goto"https://www.amazon.in/"
  when "Ey Corp Merchandise"
    @browser.goto"https://ey.corpmerchandise.com/#"
    @base_page.click_element("consent_acceptance")
  end
end

And(/^I search for the "(.*)" in "(.*)"$/) do |product, site|
  case site
  when "Ey Merch"
    @base_page.set_text_field('product_name_ey_merch', product)
    @browser.button(id: /btnSearchTerm/, type: 'submit').click
    @base_page.take_screenshot
  when "Amazon"
    @base_page.set_text_field('product_name', product)
    @browser.input(id: /nav-search-submit-button/, type: 'submit').click
  end
end

And (/^I sort the product from (.*) price and select the (.*) for test case (.*)$/)do |data, product, test_case|
  price_elements = @browser.driver.find_elements(:xpath, "//span[@id ='spnProductPrice']")
  price_array = price_elements.map{|e| e.send(:text).gsub('$', '').to_f}
  product_elements = @browser.driver.find_elements(:xpath, "//div[@class ='product-details']")
  product_array = product_elements.map{|e| e.send(:text).split("\n").first}
  price_product_pair = price_array.zip(product_array).to_h
  case data
  when "lowest"
    sorted_pair = price_product_pair.sort.to_h
  when "highest"
    sorted_pair = price_product_pair.sort_by{|key, value| key}.reverse.to_h
  end
  puts "\nSorted Pair first element #{sorted_pair.first[1]}"
  element = @browser.driver.find_element(:xpath, "//h4[contains(text(), '#{sorted_pair.first[1].split("'").first}')]/../..")
  element.click
  product_name = @product_page.send('product_name')
  price = @product_page.send('product_price')
  @base_page.take_screenshot
  @base_page.generate_report(test_case, product, product_name, price)
end

And(/^I navigate to cart$/)do
  @base_page.click_element('cart_icon')
end


And(/^I add the '(.*)' to cart$/) do |product|
  @browser.driver.find_element(:xpath, "//span[contains(text(),'#{product}') and contains(@class, 'a-size-base-plus a-color-base a-text-normal')]").click
  @search_page.click_element("add_to_cart")
end

And (/^I select the first (.*) for test case (.*)$/) do |product, test_case|
  element = @browser.driver.find_element(:xpath, "//div[@class ='product-details']/a")
  element.click
  sleep(10)
  product_name = @product_page.send('product_name')
  price = @product_page.send('product_price')
  @base_page.take_screenshot
  @base_page.generate_report(test_case, product, product_name, price)
end

And (/^I add the product to the cart$/) do
  @search_page.click_element("add_to_cart")
  @base_page.take_screenshot
end

And(/^I select the language (.*)$/) do |language|
  # element = @browser.driver.find_element(:xpath, "//a[@id = 'icp-nav-flyout']")
  # action =@browser.driver.action.move_to(element)
  # action.perform
  # @base_page.click_element("language_dropdown")
  radio_element = @browser.driver.find_element.(xpath: "//span[text() = '#{language}']/following-preceding::i")
  radio_element.click
  # elements.radio(xpath: "//span[text() = '#{language}']/following-preceding::i").click
  # @browser.radio(xpath: "//input[@type ='radio' and @value ='#{language.downcase}_IN']/following-sibling::i").click
  # @browser.radio(xpath: "//html/body/div/div/div/form/div/div/div/div/label/input[@type ='radio' and @value ='ta_IN']/following-sibling::i").click
  # @browser.radio(xpath: "/html/body/div/div/div/form/div/div/div[3]/div/label/i[@class='a-icon a-icon-radio']").click
end

And (/^I click on remove all from cart$/) do
  @cart_page.click_element('cart_icon')
  @cart_page.click_element('remove_all_item')
  @base_page.take_screenshot
end

And (/^I add multiple (.*) to the cart and capture the price of each product for test case (.*)$/)do |products, test_case|
  array_of_product = products.split(",")
  $hash_product_name_and_price = Hash.new
  product_name = []
  product_price = []
  array_of_product.each_with_index do |product, index|
    @base_page.set_text_field('product_name_ey_merch', product)
    @browser.button(id: /btnSearchTerm/, type: 'submit').click
    element = @browser.driver.find_element(:xpath, "//div[@class ='product-details']/a")
    element.click
    @search_page.click_element("add_to_cart")
    @base_page.take_screenshot
    product_name[index] = @product_page.send('product_name')
    product_price[index] = @product_page.send('product_price')
    @base_page.generate_report(test_case, products, product_name[index], product_price[index])
  end
  $hash_product_name_and_price =product_name.zip(product_price).to_h
  puts "\nhash #{$hash_product_name_and_price}"
end