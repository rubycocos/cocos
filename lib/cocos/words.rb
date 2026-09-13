
###
##
##   try  new style with Cocos::FileUtils or Cocos::IO module
##           and include module into Kernel (instead of directly)


module Cocos
module  FileUtils



## "words" or "word array.
##
##  follows  %w[] rules
##    splits on whitespace (space or newline)
##    BUT include support for inline comments!!!!
##
##    %w[apple banana cherry]
##        => ["apple", "banana", "cherry"]
##      note - allows more than one word on a line!!!!
##
##    %w[
##        ruby
##        python
##        javascript
##        go
##     ]
##      => ["ruby", "python", "javascript", "go"]
##
##  %w[] is a shorthand syntax (known as a percent literal)
##    used to create an array of strings.
##   It allows you to write an array of words without typing
##    repetitive quotation marks and commas.
##   Instead, you separate each item using whitespace (spaces or newlines).
##   note - You CANNOT use standard # comments inside %w[].
##    Ruby treats the # character as part of a literal string, which will ruin your array.
##
##
##  todo/check:
##   Option 1: The "Strict Space" Rule (Simplest & Safest)
##   In most text/config files, a comment is separated by a space
##    (e.g., key = value # comment).
##   If a # is glued to a word without a space, it is usually part of the data
##    (like a hex color #ffffff or a tag #important).
##     You can modify your code to only remove # if it is preceded by whitespace
##         color#ff0000     # red
##         color = #ff0000  # red
##   check - if this is how # is handled in yaml?
##      - Inline Comments: A # can be placed at the end of a line of data,
##                          but it must be preceded by a space.
##     e.g.  port: 8080# This will break or fail to parse correctly
##
##  e.g. use
##        line.sub( ??, '' ).strip

def parse_words( txt )
   words = []     ## array of strings
   txt.each_line( chomp: true ) do |line|

      line = line.strip

      next  if line.empty? || line.start_with?('#')

      ##  strip (inline) end-of-line comments (from line) too - keep why? why not?
      ##    ## (eat-up) REQUIRED leading (preceding) space(s) too - why? why not?
      line = line.sub( /[ \t]+#.*/, '' )

      ##  support __END__ marker for inline comments
      break  if line == '__END__'

      words += line.split( /[ \t]+/ )
   end

   words
end

alias_method :parse_wordarray, :parse_words


## todo - add (missing) read_words/wordarray too - why? why not?



end  # module FileUtils
end  # module Cocos