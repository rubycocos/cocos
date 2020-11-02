##
## "prelude / prolog " add some common used stdlibs
##   add more - why? why not?
require 'pp'
require 'time'
require 'date'
require 'json'
require 'yaml'
require 'fileutils'

require 'uri'
require 'net/http'
require 'net/https'


require 'optparse'    ## used by monofile (built-in test/debug) command line tool



#####################
# our own code
require 'monofile/version'   # note: let version always go first
require 'monofile/mononame'
require 'monofile/monofile'
require 'monofile/tool'



module Mono

  def self.root   ## root of single (monorepo) source tree
    @@root ||= begin
        ## todo/fix:
        ##  check if windows - otherwise use /sites
        ##  check if root directory exists?
        if ENV['MOPATH']
          ## use expand path to make (assure) absolute path - why? why not?
          File.expand_path( ENV['MOPATH'] )
        elsif Dir.exist?( 'C:/Sites' )
          'C:/Sites'
        else
          '/sites'
        end
    end
  end

  def self.root=( path )
    ## use expand path to make (assure) absolute path - why? why not?
    @@root = File.expand_path( path )
  end
end  ## module Mono




###
## add some convenience alias for alternate spelling (CamelCase)
MonoName = Mononame
MonoPath = Monopath
MonoFile = Monofile


puts Mono::Module::Monofile.banner   ## say hello

