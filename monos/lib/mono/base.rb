#####################
#  add file and repo helper

##
## todo/fix:  ALWAYS assert name format
##   (rename to mononame and monopath) - why? why not?

class MonoGitHub
  def self.clone( name, depth: nil )
    ## lets you use:
    ##   @rubycoco/gitti  or
    ##   gitti@rubycoco
    ##  =>  rubycoco/gitti
    norm_name = MonoFile.norm_name( name )
    path      = "#{Mono.root}/#{norm_name}"

    org_path = File.dirname( path )
    FileUtils.mkdir_p( org_path ) unless Dir.exist?( org_path )   ## make sure path exists

    ### note: use a github clone url (using ssh) like:
    ##     git@github.com:rubycoco/gitti.git
    ssh_clone_url = "git@github.com:#{norm_name}.git"

    Dir.chdir( org_path ) do
      Gitti::Git.clone( ssh_clone_url, depth: depth )
    end
  end
end
MonoGithub = MonoGitHub  ## add convenience (typo?) alias



class MonoGitProject
  def self.open( name, &block )
    path = MonoFile.real_path( name )
    Gitti::GitProject.open( path, &block )
  end
end



#### fix/todo: replace with Mononame & Monopath !!!
class MonoFile
    ## e.g. openfootball/austria etc.
    ##      expand to to "real" absolute path
    ##
    ## todo/check: assert name must be  {orgname,username}/reponame
    def self.real_path( path )
      "#{Mono.root}/#{norm_name( path )}"
    end

    def self.norm_name( path )
      #  turn
      #  - @yorobot/stage/one
      #  - one@yorobot/stage
      #  - stage/one@yorobot
      #      => into
      #  - yorobot/stage/one


      parts = path.split( '@' )
      raise ArgumentError, "no (required) @ found in name; got >#{path}<"               if parts.size == 1
      raise ArgumentError, "too many @ found (#{parts.size-1}) in name; got >#{path}<"  if parts.size > 2

      norm_name = String.new('')
      norm_name << parts[1]  ## add orgs path first
      if parts[0].length > 0   ## has leading repo name (w/ optional path)
        norm_name << '/'
        norm_name << parts[0]
      end
      norm_name
    end

    def self.exist?( path )
      File.exist?( real_path( path ))
    end


    ## path always relative to Mono.root
    ##   todo/fix:  use File.expand_path( path, Mono.root ) - why? why not?
    ##    or always enfore "absolut" path e.g. do NOT allow ../ or ./ or such
    def self.open( path, mode='r:utf-8', &block )
       full_path = real_path( path )
       ## make sure path exists if we open for writing/appending - why? why not?
       if mode[0] == 'w' || mode[0] == 'a'
        FileUtils.mkdir_p( File.dirname( full_path ) )  ## make sure path exists
       end

       File.open( full_path, mode ) do |file|
         block.call( file )
       end
    end

    def self.read_utf8( path )
       open( path, 'r:utf-8') { |file| file.read }
    end
end  ## class MonoFile



module Mono
  #################
  ## add some short cuts
  def self.open( name, &block )      MonoGitProject.open( name, &block ); end
  def self.clone( name, depth: nil ) MonoGitHub.clone( name, depth: depth ); end
  def self.real_path( name )         MonoFile.real_path( name ); end
end  ## module Mono


