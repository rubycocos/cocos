require 'cocos'


## prepare test for read_blob/binary/bin


blob = read_blob( "./test/data/marilyn.png" )

puts
puts Base64.encode64( blob )
#=>

blob2 = Base64.decode64( <<TXT )
iVBORw0KGgoAAAANSUhEUgAAABgAAAAYBAMAAAASWSDLAAAAHlBMVEUAAAAA
V7dpDEWMDVuRdlatIWDEIRDbsYD/3QD/9o7AqwunAAAAsElEQVR4nGVQuxHD
IAx9prHSwQqeIFtklBRp6Ox06owvjbsM4Z182SCkMlQE4Xx8Z50OeLz3QJIy
m1DYxB448A8wHLsvyAeSJQNyzOAgSoXAslOgIgvFTPlKFcs8QxTZw3hAzaDV
c+7HfrAiazuoJqpmwdLKP5WpKwPoLEuZkYSX19JtspfpUBi8Yhvr0+gLoxfU
OFpdKnjm9EhprZpGoyP7T3NXxH+nNNw3M2C7H8gbfQo2YCHDJXQAAAAASUVO
RK5CYII=
TXT

puts
pp blob
pp blob2

puts Base64.encode64( blob2 )

puts "bye"