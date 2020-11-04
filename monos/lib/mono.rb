require 'monofile'


## first add git support
##   note: use the "modular" version WITHOUT auto-include gitti,
##          thus, require 'gitti/base' (and NOT 'gitti')
require 'gitti/base'
require 'gitti/backup/base'


module Mono
  ## note: make Git, GitProject, GitRepoSet, etc. available without Gitti::
  include Gitti

  class Tool
    include Gitti
  end

  ## add more classes e.g. MonoGitProject, etc. - why? why not?
end




###
# our own code
require 'mono/version'      # let version always go first
require 'mono/base'
require 'mono/experimental'

require 'mono/commands/status'
require 'mono/commands/fetch'
require 'mono/commands/sync'
require 'mono/commands/env'
require 'mono/commands/backup'
require 'mono/commands/run'
require 'mono/tool'



module Mono
def self.monofile
  path = Monofile.find

  if path
    Monofile.read( path )
  else
    puts "!! WARN: no mono configuration file found; looking for #{Monofile::NAMES.join(', ')} in (#{Dir.getwd})"
    Monofile.new   ## return empty set -todo/check: return nil - why? why not?
  end
end
end  ## module Mono



puts Mono::Module::Tool.banner   # say hello
