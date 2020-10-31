$LOAD_PATH.unshift( "./lib" )
require 'monofile'


monofile = Monofile.read( "./sandbox/monofile.yml" )
pp monofile
puts
puts "to_a:"
pp monofile.to_a

puts "to_h:"
pp monofile.to_h

puts
puts "each (org,names):"
monofile.each do |org,names|
  puts "  #{org} (#{names.length}): #{names.join(', ')}"
end

puts
puts "each (project):"
monofile.each do |proj|
  puts "  #{proj}"
end

puts "size: #{monofile.size}"

