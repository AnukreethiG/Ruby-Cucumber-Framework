require 'rspec'
require 'cucumber'
require 'rubygems'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'
require 'json'
require 'rubyXL'
require 'time'
require_relative 'features/support/env'

task :execute_local, [:tag] do |task, args|
  puts "Rake Task: #{task}"
  cucumber_task = args[:tag].gsub('-', '')
  Cucumber::Rake::Task.new(:execute_local) { |task|
    task.cucumber_opts = ["features", "--format html", "--out status_report.html", "--format pretty", "--tags #{cucumber_task}"].join(' ')
  }
end

task :execute_local_json_report, [:tag] do |task, args|
  cucumber_task = args[:tag].gsub('-', '')
  timestamp = Time.now.strftime('%Y%m%d_%H%M%S')
  output_file = "status_report_#{timestamp}.json"
  Cucumber::Rake::Task.new(:execute_local_json_report) { |task|
    task.cucumber_opts = ["features", "--format json", "--out #{output_file}", "--format pretty", "--tags #{cucumber_task}"].join(' ')
  }
  output_file
end

task :json_to_excel, [:file_name] do |task, arg|
  puts "Rake Task: #{task}"
  file_name = arg[:file_name]
  puts "filename #{file_name}"
  json_data = JSON.parse(File.read(file_name))
  workbook = RubyXL::Workbook.new
  worksheet = workbook[0]
  worksheet.sheet_name = 'Cucumber Report'

  headers = ['Scenario', 'Test_Case', 'Status', 'Error_Details', 'Duration (in sec)']
  worksheet.add_cell(0, 0, headers[0])
  worksheet.add_cell(0, 1, headers[1])
  worksheet.add_cell(0, 2, headers[2])
  worksheet.add_cell(0, 3, headers[3])
  worksheet.add_cell(0, 4, headers[4])
  puts "json data #{json_data}"
  json_data.each_with_index do |feature, feature_index|
    feature['elements'].each_with_index do |scenario, scenario_index|
      test_case = scenario_index + 1
      row = feature_index + scenario_index + 1
      scenario_name = scenario['name']
      status = scenario['steps'].all? { |step| step['result']['status'] == 'passed' } ? 'Passed' : 'Failed'
      # steps = scenario['steps'].map { |step| step['name'] }.join(', ')
      duration = scenario['steps'].map { |step| step['result']['duration'] }.compact.sum / 1_000_000_000.0
      failed_steps = scenario['steps'].map { |step| step['result']['error_message']  }.compact.join(" ")
      puts "failed_step #{failed_steps}"

      worksheet.add_cell(row, 0, scenario_name)
      worksheet.add_cell(row, 1, "Example_#{test_case}")
      worksheet.add_cell(row, 2, status)
      worksheet.add_cell(row, 3, failed_steps)
      worksheet.add_cell(row, 4, duration)
    end
  end
  filename_base = File.basename(file_name, '.json')
  wb_file_name = "#{filename_base}.xlsx"
  workbook.write(wb_file_name)
  puts "Excel Report is generated: '#{wb_file_name}'"
end

task :sequential_run_task_excel_report, [:tag] do |task, args|
  output_file = Rake::Task['execute_local_json_report'].invoke(args[:tag])
  puts "output file #{output_file}"
  Rake::Task['json_to_excel'].invoke(output_file)
end