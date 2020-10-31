class Monofile
class Tool
  def self.main( args=ARGV )

    ## todo/fix:
    ##   check args - if any, use/read monofiles in args!!!
    ## todo/fix:
    ##   add optparse too; get you -h/--help

    path = Monofile.find
    if path.nil?
      puts "!! ERROR: no mono configuration file found; looking for #{Monofile::NAMES.join(', ')} in (#{Dir.getwd})"
      exit 1
    end

    ## add check for auto-require (e.g. ./config.rb)
    config_path = "./config.rb"
    if File.exist?( config_path )
      puts "[monofile] auto-require >#{config_path}<..."
      require( config_path )
    end

    puts "[monofile] reading >#{path}<..."
    monofile=Monofile.read( path )
    pp monofile

    ## print one project per line
    puts "---"
    monofile.each do |proj|
      puts proj.to_s
    end
  end
end # (nested) class Tool
end # class Monofile

