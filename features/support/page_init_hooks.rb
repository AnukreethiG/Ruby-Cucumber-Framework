Before do |scenario|
  unless scenario.source_tag_names.include? '@no_ui' and @browser.nil?
    @base_page   = BasePage.new @browser
    @search_page = SearchPage.new @browser
    @product_page = ProductPage.new @browser
    @message_page = MessagePage.new @browser
    @cart_page    = CartPage.new @browser
  end
end