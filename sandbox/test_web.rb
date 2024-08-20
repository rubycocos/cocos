require 'cocos'


###
#  try text -  json format

res = wget( 'https://live---metadata-5covpqijaa-uc.a.run.app/metadata/0' )

pp res.status
print "content-type: "
pp res.content_type
print "content-length: "
pp res.content_length

puts
pp res.text
pp res.json

write_json( "./tmp/moonbird.json", res.json )


puts
pp download_json( 'https://live---metadata-5covpqijaa-uc.a.run.app/metadata/0' )



###
#  try binary - png image

res = wget( 'https://live---metadata-5covpqijaa-uc.a.run.app/images/0' )

pp res.status
print "content-type: "
pp res.content_type
print "content-length: "
pp res.content_length


write_blob( "./tmp/moonbird1a.png", res.blob )

write_blob( "./tmp/moonbird1b.png", download_blob( 'https://live---metadata-5covpqijaa-uc.a.run.app/images/0' ))

puts "bye"

