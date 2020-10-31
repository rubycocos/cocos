class Monofile
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


    if args.size == 0   ## auto-add default arg (monofile)
      monofile_path = Monofile.find
      if monofile_path.nil?
        puts "!! ERROR: no mono configuration file found; looking for #{Monofile::NAMES.join(', ')} in (#{Dir.getwd})"
        exit 1
      end
      args << monofile_path
    end


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


    args.each do |path|
      puts "[monofile] reading >#{path}<..."
      monofile=Monofile.read( path )
      pp monofile

      ## print one project per line
      puts "---"
      monofile.each do |proj|
        puts proj.to_s
      end
    end
  end # method self.main
end # (nested) class Tool
end # class Monofile

