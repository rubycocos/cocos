#####
#  mononame (e.g. @org/hello) machinery
#  turn
#  - @openfootball/england/2020-21
#  - 2020-21@openfootball/england
#  - england/2020-21@openfootball
#      => into
#  - openfootball/england/2020-21




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
      name << parts[1]  ## add orgs/scopes path first - w/o leading @ - gets removed by split :-)
      if parts[0].length > 0   ## has leading repo name (w/ optional path)
        name << '/'
        name << parts[0]
      end

      ## pass 2) split (normalized) name/path into components (scope/name/path)
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
    raise ArgumentError, "[Mononame] expected two parts (scope/name); got #{values.pretty_inspect}"   if values.size != 2
    new( *values )
  end

  def self.real_path( line )
    ## add one-time (quick) usage convenience shortcut
    mononame = parse( line )
    mononame.real_path
  end
  class << self
    alias_method :realpath, :real_path
  end


  ## note: org/scope and name for now required
  ##   - make name optional too - why? why not?!!!
  ## use some different names / attributes ??
  attr_reader :scope,     ## todo/check: find a different name (or add alias e.g. login/user/etc.)
              :name

  alias_method :org, :scope    ## add user/login too - why? why not?
  ## e.g.  @openfootball/austria
  ##      scope => openfootball
  ##      name  => austria


  def initialize( scope, name )
    if scope.is_a?(String) && name.is_a?(String)
      @scope = scope
      @name  = name
    else
      raise ArgumentError, "[Mononame] expected two strings (scope, name); got >#{scope}< of type #{scope.class.name}, >#{name}< of type #{name.class.name}"
    end
  end

  def to_path()   "#{@scope}/#{@name}"; end
  def to_s()      "@#{to_path}"; end

  def real_path() "#{Mono.root}/#{to_path}"; end
  alias_method :realpath, :real_path

  ## todo/check: also check for /.git subfolder - why? why not?
  def exist?() Dir.exist?( real_path ); end


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
    raise ArgumentError, "[Monopath] expected three parts (scope/name/path); got #{values.pretty_inspect}"   if values.size != 3
    new( *values )
  end

  def self.real_path( line )
    monopath = parse( line )
    monopath.real_path
  end
  class << self
    alias_method :realpath, :real_path
  end


  ## note: org/scope and name AND path for now required
  ##   - make name path optional too - why? why not?!!!
  attr_reader :scope, :name, :path
  alias_method :org, :scope   ## add user/login too? why? why not?

  def initialize( scope, name, path )
     ## support/check for empty path too - why? why not?

    if scope.is_a?(String) && name.is_a?(String) && path.is_a?(String)
    ## assume [scope, name, path?]
    ##  note: for now assumes proper formatted strings
    ##   e.g. no leading @ or combined @hello/text in scope/org
    ##   or name or such
    ##  - use parse/norm_name here too - why? why not?
      @scope  = scope
      @name   = name
      @path   = path
    else
      raise ArgumentError, "[Monopath] expected three strings (scope, name, path); got >#{scope}< of type #{scope.class.name}, >#{name}< of type #{name.class.name}, >#{path}< of type #{path.class.name}"
    end
  end

  def to_path()   "#{@scope}/#{@name}/#{@path}"; end
  def to_s()      "@#{to_path}"; end

  def real_path() "#{Mono.root}/#{to_path}"; end
  alias_method :realpath, :real_path

  ## some File-like convenience helpers
  ##   e.g. File.exist?   => Monopath.exist?
  ##        File.open     => Monopath.open( ... ) { block }
  ##   etc.
  def self.exist?( line )
     File.exist?( real_path( line ) )
  end


  ## path always relative to Mono.root
  ##   todo/fix:  use File.expand_path( path, Mono.root ) - why? why not?
  ##    or always enfore "absolut" path e.g. do NOT allow ../ or ./ or such
  def self.open( line, mode='r:utf-8', &block )
    path = real_path( line )
    ## make sure path exists if we open for writing/appending - why? why not?
    if mode[0] == 'w' || mode[0] == 'a'
      FileUtils.mkdir_p( File.dirname( path ) )  ## make sure path exists
    end

    File.open( path, mode ) do |file|
      block.call( file )
    end
  end

  def self.read_utf8( line )
    open( line, 'r:utf-8') { |file| file.read }
  end
end  # class Monopath
## note: use Monopath   - avoid confusion with Monofile (a special file with a list of mono projects)!!!!





## todo/check: add a (global) Mono/Mononame converter - why? why not?
##
## module Kernel
##  def Mono( *args ) Mononame.parse( *args ); end
## end
