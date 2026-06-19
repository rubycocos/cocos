##
#
# $ ruby -I ./lib sandbox/test_find.rb

require 'cocos'



pp file = find_file( "test_find.rb", path: ['./test', './sandbox'])
pp file = find_file( "test_find.rb", path: ['test/', 'sandbox/'])

pp file = find_file( "test_find.rb", path: ['.'])
pp file = find_file( "./sandbox/test_find.rb", path: [])
pp file = find_file( '.\sandbox\test_find.rb', path: [])
pp file = find_file( "../cocos/sandbox/test_find.rb", path: [])
pp file = find_file( '..\cocos\sandbox\test_find.rb', path: [])
pp file = find_file( "sandbox/test_find.rb", path: [])

## even mixed or doubled/tripled
pp file = find_file( '..\cocos/sandbox/test_find.rb', path: [])
pp file = find_file( '..\cocos//sandbox/test_find.rb', path: [])
pp file = find_file( '..\cocos/sandbox///test_find.rb', path: [])

pp File.file?( '..\cocos/sandbox///test_find.rb' )

pp dir = find_dir( "data", path: ['.', './test'])
pp dir = find_dir( "data", path: ['.'])

## check for absolute path
pp Pathname.new('c:\hello.txt').absolute?   #=> true
pp Pathname.new('\hello.txt').absolute?     #=> true
pp Pathname.new('/hello.txt').absolute?     #=> true
pp Pathname.new('c:/hello.txt').absolute?   #=> true

pp Pathname.new('./hello.txt').absolute?   #=> false
pp Pathname.new('hello.txt').absolute?   #=> false

puts "bye"