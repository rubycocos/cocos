require 'cocos'


write_text( "./tmp/hello.txt", "hello" )

write_blob( "./tmp/blob.dat", "xxxxx" )

write_json( "./tmp/data.json", { 'name' => 'hello' } )


puts "bye"