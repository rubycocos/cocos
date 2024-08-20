##
## "prelude / prolog " add some common used stdlibs
##   add more - why? why not?
require 'pp'
require 'time'
require 'date'
require 'json'
require 'yaml'
require 'base64'    ## e.g. Base64.decode64,Base64.encode64,...
require 'fileutils'

require 'uri'
require 'net/http'
require 'net/https'
require 'cgi'

require 'optparse'    ## used by monofile (built-in test/debug) command line tool


###
# 3rd party gems
require 'csvreader'
require 'tabreader'
require 'iniparser'

require 'webclient'



#####################
# our own code
require_relative 'cocos/version'   # note: let version always go first
require_relative 'cocos/env'       ## e.g. EnvParser


###
##  read/parse convenience/helper shortcuts


module Kernel



################
#  private helpers - keep along here - why? why not?


## todo:  add symbolize options a la read_json? - why? why not?
##         add sep options

def read_csv( path, sep: nil )
  opts = {}
  opts[:sep] = sep  if sep

  CsvHash.read( path, **opts )
end

def parse_csv( str, sep: nil )
  opts = {}
  opts[:sep] = sep  if sep

  CsvHash.parse( str, **opts )
end


##  note - use explicit download for now
##
def download_csv( url, sep: nil )
  opts = {}
  opts[:sep] = sep  if sep

  parse_csv( download_text( url ),
              **opts )
end



### note: use read_data / parse_data
##  for alternate shortcut for read_csv / parse_csv w/ headers: false
##       returning arrays of strings
def read_data( path )
  Csv.read( path )
end

def parse_data( str )
  Csv.parse( str )
end

def download_data( url )
  parse_data( download_text( url ))
end



def read_tab( path )
  Tab.read( path )
end

def parse_tab( str )
  Tab.parse( str )
end

def download_tab( url )
  parse_tab( download_text( url ))
end



## todo:  add symbolize options ???
def read_json( path )
  parse_json( read_text( path ))
end

def parse_json( str )
  JSON.parse( str )
end

def download_json( url )
  parse_json( download_text( url ))
end


### todo/check:  use parse_safeyaml or such? (is default anyway?) - why? why not?
def read_yaml( path )
   parse_yaml( read_text( path ))
end

def parse_yaml( str )
  YAML.load( str )
end

def download_yaml( url )
   parse_yaml( download_text( url ))
end

## keep yml alias - why? why not?
alias_method :read_yml,     :read_yaml
alias_method :parse_yml,    :parse_yaml
alias_method :download_yml, :download_yaml


def read_ini( path )
   parse_ini( read_text( path ))
end

def parse_ini( str )
  INI.load( str )
end

def download_ini( url )
   parse_ini( download_text( url ))
end

alias_method :read_conf, :read_ini
alias_method :parse_conf, :parse_ini
alias_method :download_conf, :download_ini




def read_text( path )
   ## todo/check: add universal newline mode or such?
   ##  e.g. will always convert all
   ##    newline variants (\n|\r|\n\r) to "universal" \n only
   ##
   ##  add r:bom  - why? why not?
    File.open( path, 'r:utf-8' ) do |f|
        f.read
    end
end

def download_text( url )
  wget!( url ).text
end

alias_method :read_txt,     :read_text
alias_method :download_txt, :download_text



def read_blob( path )
    File.open( path, 'rb' ) do |f|
        f.read
    end
end
## alias_method :read_binary, :read_blob
## alias_method :read_bin,    :read_blob

def download_blob( url )
   wget!( url ).blob
end
## alias_method :download_binary, :download_blob
## alias_method :download_bin,    :download_blob



## todo/check: remove \n (or\r or \r\n) from line
##   ruby (by default) keeps the newline - follow tradition? why? why not?
##   add/offer chomp: true/false option or such - why? why not?
##    see String.lines in rdoc
##
def read_lines( path )
  read_text( path ).lines
end

def parse_lines( str )
  str.lines
end

def download_lines( url )
  parse_lines( download_text( url ))
end



def read_env( path )
   parse_env( read_text( path ))
end

def parse_env( str )
   EnvParser.load( str )
end


##
##  todo/check - change path to *paths=['./.env']
##                   and support more files - why? why not?
def load_env( path='./.env' )
  if File.exist?( path )
     puts "==> loading .env settings..."
     env = read_env( path )
     puts "    applying .env settings... (merging into ENV)"
     pp env
     ## note: will only add .env setting if NOT present in ENV!!!
     env.each do |k,v|
         ENV[k] ||= v
     end
  end
end




######
#  add writers

def write_json( path, data )
  ###
  ## todo/check:  check if data is Webclient.Response?
  ##   if yes use res.json  - why? why not?

  dirname = File.dirname( path )
  FileUtils.mkdir_p( dirname )  unless Dir.exist?( dirname )

  ## note: pretty print/reformat json
  File.open( path, 'w:utf-8' ) do |f|
     f.write( JSON.pretty_generate( data ))
  end
end


def write_blob( path, blob )
  ###
  ## todo/check:  check if data is Webclient.Response?
  ##   if yes use res.blob/body  - why? why not?

  dirname = File.dirname( path )
  FileUtils.mkdir_p( dirname )  unless Dir.exist?( dirname )

  File.open( path, 'wb' ) do |f|
    f.write( blob )
  end
end
# alias_method :write_binary, :write_blob
# alias_method :write_bin,    :write_blob


def write_text( path, text )
  ###
  ## todo/check:  check if data is Webclient.Response?
  ##   if yes use res.text  - why? why not?

  dirname = File.dirname( path )
  FileUtils.mkdir_p( dirname )  unless Dir.exist?( dirname )

  File.open( path, 'w:utf-8' ) do |f|
    f.write( text )
  end
end
alias_method :write_txt,  :write_text



#
# note:
#  for now write_csv expects array of string arrays
#     does NOT support array of hashes for now

def write_csv( path, recs, headers: nil )
  dirname = File.dirname( path )
  FileUtils.mkdir_p( dirname )  unless Dir.exist?( dirname )

  File.open( path, 'w:utf-8' ) do |f|
    if headers
      f.write( headers.join(','))   ## e.g. Date,Team 1,FT,HT,Team 2
      f.write( "\n" )
    end

    recs.each do |values|
      ## quote values that incl. a comma
      ##  todo/fix - add more escape/quote checks - why? why not?
      ##   check how other csv libs handle value generation
      buf =  values.map do |value|
               if value.index(',')
                  %Q{"#{value}"}
               else
                  value
               end
             end.join( ',' )

      f.write( buf )
      f.write( "\n" )
    end
  end
end



######
#   world wide web (www) support

def wget( url, **opts )
  Webclient.get( url, **opts )
end
##  add alias www_get or web_get - why? why not?

def wget!( url, **opts )
  res = Webclient.get( url, **opts )

  ##  check/todo - use a different exception/error - keep RuntimeError - why? why not?
  raise RuntimeError, "HTTP #{res.status.code} - #{res.status.message}"   if res.status.nok?

  res
end


end # module Kernel





####
#  convenience alias  (use plural or singual)
Coco = Cocos


puts Cocos.banner   ## say hello

