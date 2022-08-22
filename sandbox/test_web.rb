require 'cocos'


###
#  try text -  json format

res = wget( 'https://live---metadata-5covpqijaa-uc.a.run.app/metadata/0' )

pp res.status
pp res.content_type
pp res.content_length

puts
pp res.text
pp res.json


###
#  try binary - png image

write_json( "./tmp/moonbird.json", res.json )


res = wget( 'https://live---metadata-5covpqijaa-uc.a.run.app/images/0' )

pp res.status
pp res.content_type
pp res.content_length

puts

write_blob( "./tmp/moonbird.png", res.blob )


puts "bye"