#####################
#  add repo helper

##
## todo/fix:  ALWAYS assert name format
##   (rename to mononame and monopath) - why? why not?

class MonoGitHub
  def self.clone( name, depth: nil )
    ## lets you use:
    ##   @rubycoco/gitti  or
    ##   gitti@rubycoco
    ##  =>  rubycoco/gitti
    mononame  = Mononame.parse( name )
    path      = mononame.real_path

    org_path = File.dirname( path )
    FileUtils.mkdir_p( org_path ) unless Dir.exist?( org_path )   ## make sure path exists

    ### note: use a github clone url (using ssh) like:
    ##     git@github.com:rubycoco/gitti.git
    ssh_clone_url = "git@github.com:#{mononame.to_path}.git"

    Dir.chdir( org_path ) do
      Gitti::Git.clone( ssh_clone_url, depth: depth )
    end
  end
end
MonoGithub = MonoGitHub  ## add convenience (typo?) alias



class MonoGitProject
  def self.open( name, &block )
    mononame = Mononame.parse( name )
    path     = mononame.real_path
    Gitti::GitProject.open( path, &block )
  end
end



module Mono
  #################
  ## add some short cuts
  def self.open( name, &block )      MonoGitProject.open( name, &block ); end
  def self.clone( name, depth: nil ) MonoGitHub.clone( name, depth: depth ); end
end  ## module Mono


