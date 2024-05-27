Before do |scenario|
  puts("\n-------------Scenario Start ------------")
  ENV['TAGS'] ||= scenario.source_tag_names.to_s
  @start_time = Time.now
  puts @scenario_name = scenario.source_tag_names.to_s
  @browser = BrowserUtilities.launch_browser
  BrowserUtilities.resize_browser
end

After do |scenario|
  @finish_time = Time.now
  puts "\nTime taken for scenario execution: #{Time.at(@finish_time - @start_time).utc.strftime("%H:%M:%S.%L")}"
  puts "\nScenario Passed?: #{scenario.passed?}"
  @browser.close unless @browser.nil?
  puts("\n-------------Scenario Stop ------------")
end