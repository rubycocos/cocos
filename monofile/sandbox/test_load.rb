$LOAD_PATH.unshift( "./lib" )
require 'monofile'


monofile = Monofile.load( <<TXT )

### some comments
project "@openfootball/england"
project "@openfootball/world-cup"
project "@geraldb/austria"

project "geraldb", "catalog"
project :openfootball, :"south-america"

puts "class: " + self.class.name   #=> Monofile::Builder
## try "batch" adding projects
projects( {},
          { 'footballcsv':
             ['england', 'world'] }
        )


puts "hello from monofile"
TXT



puts "---"
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

