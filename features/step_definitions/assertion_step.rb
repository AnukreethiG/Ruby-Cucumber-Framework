require 'watir'

And(/^I validate the success message (.*)$/)do |message|
  if expect(@message_page.send("message_element").text.downcase ).to eq message.downcase
    puts "\n Product is added Successfully to cart"
  else
    puts "\n Product is not added to cart"
  end

end

And (/^I validate the "(.*)" message$/) do |message|
  text = @product_page.send("message")
  if message == text
    puts "\nProduct added to cart; \nMessage: #{text}"
  else
    puts "\nProduct is not added to cart; \nMessage: #{text}"
  end
  @base_page.take_screenshot
end

And(/^I click on Cart icon and validate "(.*)" is available in cart$/) do |product|
  @base_page.click_element("cart_icon")
  sleep(5)
  elements = @browser.driver.find_elements(:id, "artifi-design-edit").select { |element| element.text.include?(product) }
  element_containing_txt = elements.select{ |element| element.text.include?(product) }
  txt = element_containing_txt.each do |element|
  puts "\ntxt1 = #{element.text} exist in cart"
  end
  @base_page.take_screenshot
end

And (/^I click on language dropdown$/) do
  @base_page.click_element("language_dropdown")
end

And(/^I print the available language option$/) do
  sleep(5)
  elements = @browser.driver.find_elements(:xpath, "//div[@id='icp-language-settings']")
  txt = Array.new
  elements.each do |element|
    txt = (element.text).to_sym
    puts "txt1 = #{txt}"
  end
end

And (/^I validate no item available in cart$/) do
  sleep(5)
  begin
  @browser.driver.find_element(:xpath, "//p[contains(text(), 'No Items Found In Your Cart')]")
    puts "\nCart is empty"
  rescue
    Selenium::WebDriver::Error::NoSuchElementError
    puts "\nCart is not empty"
  end
  @base_page.take_screenshot
  end
And(/^I validate (.*) subtotal in the cart$/) do |products|
  array_of_product = products.split(",")
  product_array = $hash_product_name_and_price.keys
  price_array = $hash_product_name_and_price.values.map {|element| element.gsub('$', '').to_f}
  expected_price_sum = price_array.sum
  puts "Expected in cart #{expected_price_sum}"
  sleep(5)
  element = @browser.driver.find_element(:xpath, "//span[@class ='icon-shopping-cart']")
  sleep(5)
  element.click
  sleep(5)
  array_of_product.each_with_index do |product, index|
    elements = @browser.driver.find_elements(:id, "artifi-design-edit").select { |element| element.text.include?(product_array[index]) }
    puts "\n Element #{product_array[index]} exist in cart"
  end
  total_amount = @cart_page.send('total_amount').gsub('$', '').to_f
  if total_amount == expected_price_sum
    puts "\nPrice got tally"
  else
    puts "\nPrice mismatch"
  end
end