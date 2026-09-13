##
#
# $ ruby -I ./lib sandbox/test_words.rb

require 'cocos'



pp parse_words( <<TXT )
  apple banana cherry
TXT

pp parse_wordarray( <<TXT )
  apple banana cherry
TXT
#=> ["apple", "banana", "cherry"]

pp parse_words( <<TXT )
        ruby
        python
        javascript
        go
TXT
#=> ["ruby", "python", "javascript", "go"]


puts "bye"