
class Monofile
  ## holds a list of projects

  ## nested class
  class Project    ## todo/fix: change to Monoproject/MonoProject - why? why not?
    def initialize( *args )
      if args.size == 2 && args[0].is_a?(String) && args[1].is_a?(String)
        ## assume [org, name]
        @name = Mononame.new( *args )
      elsif args.size == 1 && args[0].is_a?( String )
        @name = Mononame.parse( args[0] )
      else
        raise ArgumentError, "[MonoProject] one or two string args expected; got: #{args.pretty_inspect}"
      end
    end

    def org()     @name.org; end
    def name()    @name.name; end

    def to_path() @name.to_path; end
    def to_s()    @name.to_s; end

    ## add clone_ssh_url  or such too!!!!
  end  ## (nested) class Project



  class Builder     ## "clean room" pattern/spell - keep accessible methods to a minimum (by eval in "cleanroom")
    def initialize( monofile )
      @monofile = monofile
    end

    def project( *args )
      project = Project.new( *args )
      @monofile.projects << project
    end
  end  # (nested) class Builder



  RUBY_NAMES = ['monofile',
                'Monofile',
                'monofile.rb',
                'Monofile.rb',
               ]

  TXT_NAMES  = ['monofile.txt',
                'monotree.txt',  ## keep monotree - why? why not?
                'monorepo.txt',
                'repos.txt']

  ## note: yaml always requires an extension
  YML_NAMES = ['monofile.yml',   'monofile.yaml',
                'monotree.yml',   'monotree.yaml',  ## keep monotree - why? why not?
                'monorepo.yml',   'monorepo.yaml',
                'repos.yml',      'repos.yaml',
               ]    ## todo/check: add mono.yml too - why? why not?

  NAMES = RUBY_NAMES + TXT_NAMES + YML_NAMES


  def self.find
    RUBY_NAMES.each do |name|
      return "./#{name}"  if File.exist?( "./#{name}")
    end

    TXT_NAMES.each do |name|
      return "./#{name}"  if File.exist?( "./#{name}")
    end

    YML_NAMES.each do |name|
      return "./#{name}"  if File.exist?( "./#{name}")
    end

    nil  ## no monofile found; return nil
  end


  def self.read( path )
      txt  = File.open( path, 'r:utf-8') { |f| f.read }

      ## check for yml or yaml extension;
      ##    or for txt extension; otherwise assume ruby
      extname = File.extname( path ).downcase
      if ['.yml', '.yaml'].include?( extname )
        hash = YAML.load( txt )
        new( hash )
      elsif ['.txt'].include?( extname )
        new( txt )
      else  ## assume ruby code (as text in string)
        new().load( txt )
      end
  end



  def self.load( code )
    monofile = new
    monofile.load( code )
    monofile
  end

  def self.load_file( path )  ## keep (or add load_yaml to or such) - why? why not?
    code  = File.open( path, 'r:utf-8') { |f| f.read }
    load( code )
  end


  ### attr readers
  def projects() @projects; end
  def size()     @projects.size; end


  def initialize( obj={} )    ## todo/fix: change default to obj=[]
    @projects = []

    ## puts "[debug] obj.class=#{obj.class.name}"
    add( obj )
  end

  def load( code )  ## note: code is text as a string
    builder = Builder.new( self )
    builder.instance_eval( code )
    self  ## note: for chaining always return self
  end


  def add( obj )
    ## todo/check: check for proc too! and use load( proc/block ) - possible?
    if obj.is_a?( String )
      puts "sorry add String - to be done!!!"
      exit 1
    elsif obj.is_a?( Array )
      puts "sorry add Array- to be done!!!"
      exit 1
    elsif obj.is_a?( Hash )
      add_hash( obj )
    else  ## assume text (evaluate/parse)
      puts "sorry add Text - to be done!!!"
      exit 1
    end
    self ## note: return self for chaining
  end


  def add_hash( hash )
    hash.each do |org_with_counter, names|

      ## remove optional number from key e.g.
      ##   mrhydescripts (3)    =>  mrhydescripts
      ##   footballjs (4)       =>  footballjs
      ##   etc.

      ## todo/check: warn about duplicates or such - why? why not?

      org = org_with_counter.sub( /\([0-9]+\)/, '' ).strip.to_s

      names.each do |name|
        @projects << Project.new( org, name )
      end
    end

    self  ## note: return self for chaining
  end



  def each( &block )
      ## puts "[debug] arity: #{block.arity}"

      ## for backwards compatibility support "old" each with/by org & names
      ##   add deprecated warnings and use to_h or such - why? why not?
      if block.arity == 2
        puts "!! DEPRECATED  - please, use Monofile#to_h or Monofile.each {|proj| ...}"
        to_h.each do |org, names|
          block.call( org, names )
        end
      else
        ## assume just regular
        @projects.each do |project|
          block.call( project )
        end
      end
  end # method each

  def each_with_index( &block )
    @projects.each_with_index do |project,i|
       block.call( project, i )
    end
  end



  ### for backward compat(ibility) add a hash in the form e.g:
  ##
  ## geraldb:
  ## - austria
  ## - catalog
  ## - geraldb.github.io
  ## - logos
  ## yorobot:
  ## - auto
  ## - backup
  ## - football.json
  ## - logs
  ##
  def to_h
    h = {}
    @projects.each do |project|
      h[ project.org ] ||= []
      h[ project.org ] << project.name
    end
    h
  end

  def to_a
    ## todo/check:
    ##   - sort all entries a-z - why? why not?
    ##   - always start name with @ marker - why? why not?
    @projects.map {|project| project.to_s }
  end
end # class Monofile



