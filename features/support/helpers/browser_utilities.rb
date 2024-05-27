class BrowserUtilities

  attr_accessor :BrowserUtilities

  def self.launch_browser
    browser_type = ENV['BROWSER']
    puts "browser_type: #{browser_type}"

    @browser = case browser_type.downcase
               when 'chrome'
                 chrome_driver_path = "#{File.dirname(__FILE__ )}/../driver/chromedriver.exe"
                 Selenium::WebDriver::Chrome::Service.driver_path = chrome_driver_path
                 Watir::Browser.new(:chrome)
               end
  end

  def self.resize_browser
    screen_width = @browser.execute_script('return screen.width;')
    screen_height = @browser.execute_script('return screen.height;') - 50
    width, height = ENV['width'].nil? ? [screen_width, screen_height] : [ENV['width'], ENV['height']]
    @browser.window.move_to(0, 0)
    @browser.window.resize_to(width, height)
  end
end
