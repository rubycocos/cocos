###
# simple read_env, load_env machinery
##   inspired by
##      dotenv gem -> https://github.com/bkeepers/dotenv
##      figaro     -> https://github.com/laserlemon/figaro  
##      and others


##  todo/check:
##    move to its own (standandaloen) envparser gem - why? why not?

module EnvParser
    # returns a hash
    #  (compatible structure - works like YAML.load_file)
    #
    #   change to .read(path) and parse( text) - why? why not?
    def self.load_file( path )
        text = File.open( path, 'r:utf-8' ) { |f| f.read }
        parse( text )
    end
    def self.load( text )   parse( text ); end
 
    
    class Error < StandardError; end
  
    ## todo/check - what is JSON and YAML returning Parser/ParseError something else?
    ##  YAML uses ParseError  and JSON uses ParserError
    class ParseError < Error; end
  

    ## todo/check - if support for empty values e.g. abc=  is required/possible???
    ##  todo/ addd support for quoted values - why? why not?
    ##  add support for "inline" end of line comments - why? why not?
    ##  add support for escapes and multi-line values - why? why not?
LINE_RX = /\A(?<key>[A-Za-z][A-Za-z0-9_-]*)
                 [ ]*
                   =
                 [ ]*
               (?<value>.+?)    ## non-greedy
              \z
             /x

  ## use a parser class - why? why not?
  def self.parse( text )
   h = {}

   lineno = 0   
  text.each_line do |line|
    lineno += 1    ## track line numbers for (parse) error reporting

    line = line.strip   ## check: use strip (or be more strict) - why? why not?
    ## skip empty and comment lines
    next if line.empty? || line.start_with?( '#' )

    if m=LINE_RX.match(line)
      key   = m[:key]
      value = m[:value]
      
      ## todo/check - check/warn about duplicates - why? why not?
      h[key] = value
   else 
      raise ParseError,  "line #{lineno} - unknown line type; cannot parse >#{line}<"
   end
  end
  h
end   # methdod self.parse
end  # module EnvParser

  

__END__

# parser regex from dotenv

LINE = /
(?:^|\A)              # beginning of line
\s*                   # leading whitespace
(?:export\s+)?        # optional export
([\w.]+)              # key
(?:\s*=\s*?|:\s+?)    # separator
(                     # optional value begin
  \s*'(?:\\'|[^'])*'  #   single quoted value
  |                   #   or
  \s*"(?:\\"|[^"])*"  #   double quoted value
  |                   #   or
  [^\#\r\n]+          #   unquoted value
)?                    # value end
\s*                   # trailing whitespace
(?:\#.*)?             # optional comment
(?:$|\z)              # end of line
/x
