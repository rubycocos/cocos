$LOAD_PATH.unshift( "./lib" )
require 'mono'

puts
puts Mono.root


repos = Mono.walk

puts
puts "#{repos.size} repos:"
puts repos

puts
puts "bye"
