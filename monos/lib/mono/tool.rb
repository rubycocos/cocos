module Mono


class Tool
  def self.main( args=ARGV )

    options = {}
    OptionParser.new do |parser|
      ## note:
      ##  you can add many/multiple modules
      ##  e.g. -r gitti -r mono etc.
      parser.on( '-r NAME', '--require NAME') do |name|
        options[:requires] ||= []
        options[:requires] << name
      end
      ## todo/fix:
      ##    add --verbose
      ##    add -d/--debug
    end.parse!( args )


    ## add check for auto-require (e.g. ./config.rb)
    if options[:requires]  ## use custom (auto-)requires
      options[:requires].each do |path|
        puts "[monofile] auto-require >#{path}<..."
        require( path )
      end
    else  ## use/try defaults
      config_path = "./config.rb"
      if File.exist?( config_path )
        puts "[monofile] auto-require (default) >#{config_path}<..."
        require( config_path )
      end
    end


   ## note: for now assume first argument is command
   cmd = if args.size == 0
           'status'   ## make status "default" command
         else
           args.shift   ## remove first (head) element
         end

   ## note: allow shortcut for commands
   case cmd.downcase
   when 'status', 'stati', 'stat', 'st', 's'
      status
   when 'sync', 'syn', 'sy',  ## note: allow aliases such as install, get & up too
        'get', 'g',
        'install', 'insta', 'inst', 'ins', 'i',
        'up', 'u'
      sync
   when 'fetch', 'f'
      fetch
   when 'env', 'e'
      env
   when 'backup', 'back', 'b'
      backup
   when 'run', 'r', 'exec'
      run( args )


   ##################
   ## for debugging / linting
   when 'walk'
      Mono.walk
   else
     puts "!! ERROR: unknown command >#{cmd}<"
     exit 1
   end

  end  # method self.main
end # class Tool

end # module Mono