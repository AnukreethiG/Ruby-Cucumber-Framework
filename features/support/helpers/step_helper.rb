def wait_until_true(description = nil, option = {})
  option = description if description.is_a? Hash
  delay = option.delete(:delay) || 0.5
  timeout = option.delete(:timeout) || 0.5
  raise "Invalid options: #{option}" unless option.empty?
  start = Time.now
  stop = start + timeout
  @event_start = start
  until yield || @event_start >= stop
    sleep delay
    @event_start = Time.now
  end
  if @event_start >= stop
    puts "Max timeout reached, block is false, description: #{description}"
    false
  else
    true
  end
end

def do_until_true(description = nil, option = {})
  option = description if description.is_a? Hash
  delay = option.delete(:delay) || 0.5
  timeout = option.delete(:timeout) || 0.5
  raise "Invalid options: #{option}" unless option.empty?
  start = Time.now
  stop = start + timeout
  @event_start = start
  until yield || @event_start >= stop
    sleep delay
    @event_start = Time.now
  end
  raise Timeout::Error, "Timed out, set time '#{timeout}' seconds id over waiting for condition: '#{description}'" if @event_start >= stop
  true
end