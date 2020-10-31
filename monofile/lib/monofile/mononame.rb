#####
#  mononame (e.g. @org/hello) machinery
#  turn
#  - @yorobot/stage/one
#  - one@yorobot/stage
#  - stage/one@yorobot
#      => into
#  - yorobot/stage/one




module Mono
  ## shared parse/norm helper (for Name/Path)
  ##  - find something better - why? why not?
  def self.parse_name( line )
    if line.is_a?( String )
      parts = line.split( '@' )
      raise ArgumentError, "[Mononame] no @ found BUT required in name; got >#{line}<"               if parts.size == 1
      raise ArgumentError, "[Mononame] too many @ found (#{parts.size-1}) in name; got >#{line}<"    if parts.size > 2

      ## pass 1) rebuild (normalized) name/path
      name = String.new('')
      name << parts[1]  ## add orgs path first - w/o leading @ - gets removed by split :-)
      if parts[0].length > 0   ## has leading repo name (w/ optional path)
        name << '/'
        name << parts[0]
      end

      ## pass 2) split (normalized) name/path into components (org/name/path)
      parts = name.split( '/' )

      args = [parts[0], parts[1]]

      more_parts = parts[2..-1]  ## check for any extra (optional) path parts
      args << more_parts.join( '/' )    if more_parts.size > 0

      args
    else
      raise ArgumentError, "[Mononame] string with @ expected; got: #{line.pretty_inspect} of type #{line.class.name}"
    end
  end
end  # module Mono



class Mononame
  def self.parse( line )
    values = Mono.parse_name( line )
    raise ArgumentError, "[Mononame] expected two parts (org/name); got #{values.pretty_inspect}"   if values.size != 2
    new( *values )
  end


  def self.real_path( line )
    ## add one-time (quick) usage convenience shortcut
    name = parse( line )
    name.real_path
  end

  ## todo/fix: add real_path


  ## note: org and name for now required
  ##   - make name optional too - why? why not?!!!
  ## use some different names / attributes ??
  attr_reader :org,     ## todo/check: find a different name (or add alias e.g. login/user/etc.)
              :name

  def initialize( org, name )
    if org.is_a?(String) && name.is_a?(String)
      @org  = org
      @name = name
    else
      raise ArgumentError, "[Mononame] expected two strings (org, name); got >#{org}< of type #{org.class.name}, >#{name}< of type #{name.class.name}"
    end
  end

  def to_path() "#{@org}/#{@name}"; end
  def to_s()    "@#{to_path}"; end
end # class Mononame



####
## todo/check:
##   use as shared Mono/nomen/resource or such
#   shared base class for Mononame & Monopath - why? why not?
#
#  Monoloc  (for location)
#  Monores  (for resource)
#  Mono__ ??
#
#  name components:
#    - better name for path?  - use filepath, relpath, ...



class Monopath
  def self.parse( line )
    values = Mono.parse_name( line )
    raise ArgumentError, "[Monopath] expected three parts (org/name/path); got #{values.pretty_inspect}"   if values.size != 3
    new( *values )
  end

  ## note: org and name AND path for now required
  ##   - make name path optional too - why? why not?!!!
  attr_reader :org, :name, :path

  def initialize( org, name, path )
     ## support/check for empty path too - why? why not?

    if org.is_a?(String) && name.is_a?(String) && path.is_a?(String)
    ## assume [org, name, path?]
    ##  note: for now assumes proper formatted strings
    ##   e.g. no leading @ or combined @hello/text in org
    ##   or name or such
    ##  - use parse/norm_name here too - why? why not?
      @org  = org
      @name = name
      @path = path
    else
      raise ArgumentError, "[Monopath] expected three strings (org, name, path); got >#{org}< of type #{org.class.name}, >#{name}< of type #{name.class.name}, >#{path}< of type #{path.class.name}"
    end
  end

  def to_path() "#{@org}/#{@name}/#{@path}"; end
  def to_s()    "@#{to_path}"; end
end  # class Monopath
## note: use Monopath   - avoid confusion with Monofile (a special file with a list of mono projects)!!!!





## todo/check: add a (global) Mono/Mononame converter - why? why not?
##
## module Kernel
##  def Mono( *args ) Mononame.parse( *args ); end
## end
