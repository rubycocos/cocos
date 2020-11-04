#####################
#  add repo helper


class MonoGitHub
  def self.clone( name, depth: nil )
    ## lets you use:
    ##   @rubycoco/gitti  or
    ##   gitti@rubycoco
    ##  =>  rubycoco/gitti

    ## note: allow passing in (reusing) of mononames too
    mononame =  name.is_a?( Mononame ) ? name : Mononame.parse( name )
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
    ## note: allow passing in (reusing) of mononames too
    mononame = name.is_a?( Mononame ) ? name : Mononame.parse( name )
    path     = mononame.real_path
    Gitti::GitProject.open( path, &block )
  end
end




module Mono
  #################
  ## add some short cuts
  def self.open( name, &block )      MonoGitProject.open( name, &block ); end
  def self.clone( name, depth: nil ) MonoGitHub.clone( name, depth: depth ); end

  ######################################
  ## add some more "porcelain" helpers
  def self.sync( name )
     ## add some options - why? why not?
     ##  -  :readonly    - auto-adds  depth: 1 on clone or such - why? why not?
     ##  -  :clone  true/false  - do NOT clone only fast forward or such - why? why not?
     ##  -  :clean  true/false or similar  - only clone repos; no fast forward
     ##  others - ideas -- ??

     ## note: allow passing in (reusing) of mononames too
     mononame =  name.is_a?( Mononame ) ? name : Mononame.parse( name )
     if mononame.exist?
       MonoGitProject.open( mononame ) do |proj|
         if proj.changes?
           puts "!! WARN - local changes in workdir; skipping fast forward (remote) sync / merge"
         else
           proj.fast_forward   ## note: use git pull --ff-only (fast forward only - do NOT merge)
         end
       end
     else
       MonoGitHub.clone( mononame )
     end
  end # method self.sync
end  ## module Mono


