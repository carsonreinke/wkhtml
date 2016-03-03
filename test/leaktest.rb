#Arguments are type and time
type, time = ARGV
type ||= :pdf
type = type.to_sym()
time ||= 10
time = time.to_i()

puts "Testing #{type}"
puts "Running for #{time} minutes"

pid = fork do
  Signal.trap('INT') do
    Kernel.exit()
  end
  
  $:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  require 'wkhtml'
  
  converter = WkHtml::Converter.new('<html><body>My Test</body></html>')
  loop do
    converter.__send__(:"to_#{type}")
    GC.start()
    sleep 1
  end
end

#Give some time for initial reading
sleep 60 * 1
old_size = `ps -o rss -p #{pid}`.strip.split.last.to_i * 1024

#Take final reading
sleep 60 * time
new_size = `ps -o rss -p #{pid}`.strip.split.last.to_i * 1024
Process.kill('INT', pid)
puts "Difference after #{time} minutes is #{new_size - old_size} bytes"