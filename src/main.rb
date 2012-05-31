#!/usr/bin/env macruby
require 'optparse'
require 'snappy'
require 'version'

options = {}
parser = OptionParser.new do |opts|
  opts.banner = 'Usage: snappy [<options> <filename>]'
  opts.separator ''
  opts.separator 'Options:'
  opts.on('-d', '--device DEVICE', 'Set the device to use by name') { |d| options[:d] = d }
  opts.on('-w', '--wait SECONDS', 'Wait seconds before to take the snapshot') { |w| options[:w] = w }
  opts.on('-hrs', '--hours HOURS', 'Take pictures for this amount of hours') { |hrs| options[:hrs] = hrs }
  opts.on('-dir', '--directory', 'Path to directory for pictures') { |dir| options[:pictures_directory] = dir }
  opts.on_tail('-l', '--list', 'Show available devices') { puts Snappy.devices_list; exit }
  opts.on_tail('-v', '--version', 'Print version') { puts Snappy::VERSION; exit }
  opts.on_tail('-h', '--help', 'Show this help message') { puts opts; exit }
end

begin
  parser.parse!
rescue OptionParser::InvalidOption
  puts parser.help; exit
end

if ARGV.size > 1
  puts parser.help; exit
end

options[:filename] = ARGV[0]

end_time = Time.now + options[:hrs].to_i*3600 unless options[:hrs].nil?


while end_time - Time.now > 0 do
  Snappy.alloc.init(options).snap
end