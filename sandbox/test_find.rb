##
#
# $ ruby -I ./lib sandbox/test_find.rb

require 'cocos'



pp file = find_file( "test_find.rb", path: ['./test', './sandbox'])
pp file = find_file( "test_find.rb", path: ['test/', 'sandbox/'])

pp file = find_file( "test_find.rb", path: ['.'])
pp file = find_file( "./sandbox/test_find.rb", path: [])
pp file = find_file( "sandbox/test_find.rb", path: [])


puts "bye"