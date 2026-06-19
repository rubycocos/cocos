

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
    raise Errno::ENOENT, "file #{name.inspect} not found; looking in path #{path.inspect}"   if filepath.nil?
    filepath
end

##
##  note - find_file will NOT find directories!!!
##                          File.file? will only check if a file (not directory) exits!!

##
## todo/check - expand path and use File.realpath too?
##           or keep "simple" File.join ?

##
##  note - always expand path for now and return absolute path!
##
##  note - do NOT search path if name passed in is absolute!!!
def find_file( name, path: )
    filepath = File.expand_path( name )
    return filepath   if File.file?( filepath )

##  note - if name starts with root / or c:\
##          assume it's absolute - handle by Pathname lib for now
##    do NOT search!!!
    return nil    if Pathname.new(name).absolute?

    path.each do |basedir|
        filepath = File.expand_path( name, basedir )
        return filepath   if File.file?( filepath )
    end

    nil   ## return nil if not found
end



def find_dir( name, path: [] )
    dirpath = File.expand_path( name )
    return dirpath   if Dir.exist?( dirpath )

##  note - if name starts with / or \ assume it's absolute!!
##    do NOT search!!!
##     note - search still works for
##               ./austria  or ../austria or such
##
##  todo/check/fix-fix-fix
##     is there a File.absolute? or such method for reuse??
##
##  todo/fix-fix-fix add absolute check upstream to find_file too!!!
   ## return nil    if name.start_with?( %r{[/\\]} )
   ##  note - Pathname#absolute? is basically !Pathname#relative? !!!
      return nil    if Pathname.new(name).absolute?

    path.each do |basedir|
        ## todo/check -  always make sure basedir is an absolute/expanded path - why? why not?
        dirpath = File.expand_path( name, basedir )
        return dirpath   if Dir.exist?( dirpath )
    end

    nil   ## return nil if not found
end



end  # module Kernel
