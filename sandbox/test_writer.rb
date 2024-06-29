require 'cocos'


write_text( "./tmp/hello.txt", "hello" )

write_blob( "./tmp/blob.dat", "xxxxx" )

write_json( "./tmp/data.json", { 'name' => 'hello' } )


recs = [['a1',  'b1'],
        ['a2',  'b2'],
        ['a3,x','b3'],
        ['a4',  'b4,y']]
write_csv( "./tmp/one.csv", recs )
write_csv( "./tmp/two.csv", recs, headers: ['a', 'b'] )

puts "bye"

