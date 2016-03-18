#Arguments are type and time
type, time, in_file, out_file = ARGV
type ||= :pdf
type = type.to_sym()
time ||= 10
time = time.to_i()
in_file = nil if !in_file.nil?() && in_file.empty?()
out_file = nil if !out_file.nil?() && out_file.empty?()

puts "Testing #{type}"
puts "Running for #{time} minutes"

pid = fork do
  $stop_loop = false
  Signal.trap('INT') do
    puts 'Interrupt'
    $stop_loop = true
  end
  
  $:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  require 'wkhtml'
  
  converter = WkHtml::Converter.new("<html><body>#{'Test' * 100_000}</body></html>")
  
  puts 'Running GC'
  while !$stop_loop
    GC.start()
    sleep 0.1
  end
  $stop_loop = false
  
  #puts ObjectSpace.count_objects
  
  puts 'Running tests'
  while !$stop_loop
    if out_file.nil?()
      converter.__send__(:"to_#{type}")
    else
      converter.to_file(out_file, type)
    end
    GC.start()
    sleep 1
  end
  $stop_loop = false
  
  puts 'Running GC'
  while !$stop_loop
    GC.start()
    sleep 0.1
  end
  
  #puts ObjectSpace.count_objects
  
  Kernel.exit(0)
end

#Give some time for initial reading
sleep 10
old_size = `ps -o rss -p #{pid}`.tap{|o| puts o}.strip.split.last.to_i
Process.kill('INT', pid)

time.times do |i|
  new_size = `ps -o rss -p #{pid}`.tap{|o| puts o}.strip.split.last.to_i
  puts "Difference after #{i} minutes is #{new_size - old_size}"
  sleep 60
end

#Take final reading
Process.kill('INT', pid)
sleep 10
new_size = `ps -o rss -p #{pid}`.strip.split.last.to_i
puts "Difference after #{time} minutes is #{new_size - old_size}"
Process.kill('INT', pid)