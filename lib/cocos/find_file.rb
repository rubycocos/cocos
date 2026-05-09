

##
## note - use File.file? instead of File.exist?
##            (checks if file exists AND file is a file NOT a directory)
##
##
##   add  option - raise_on_error: false  - why? why not?
##     def find_file!  - find_file(  raise_on_error: false )
##
##  todo/check
##    golang  lookup_path or such
##     always return absolute (expanded) path - why? why not?


module Kernel

def find_file!( name, path: )
    filepath = find_file( name, path: path )
    raise Errorno::ENOENT, "file <#{name}> not found; looking in path #{path.inspect}"   if filepath.nil?
    filepath
end

##
##  note - find_file will NOT find directories!!!
##                          File.file? will only check if a file (not directory) exits!!


##
## todo/check - expand path and use File.realpath too?
##           or keep "simple" File.join ?

def find_file( name, path: )
    return name    if File.file?( name )

    path.each do |dir|
        filepath = File.join( dir, name )
        return filepath   if File.file?( filepath )
    end

    nil   ## return nil if not found
end


end  # module Kernel
