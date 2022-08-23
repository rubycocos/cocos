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
require 'cocos/version'   # note: let version always go first


###
##  read/parse convenience/helper shortcuts


module Kernel



################
#  private helpers - keep along here - why? why not?

##### check if path starts with http:// or https://
##       if yes, assume it's a download
DOWNLOAD_RX = %r{^https?://}i

## note: hack - use !! to force nil (no match) to false
##                         and matchdata to true
def _download?( path )
   !! DOWNLOAD_RX.match( path )
end



## todo:  add symbolize options a la read_json
##         add sep options
def read_csv( path, headers: true )

   if _download?( path )
     parse_csv( _wget!( path ).text,
                headers: headers )
   else
     if headers
        CsvHash.read( path )
     else
        Csv.read( path )
     end
    end
end

def parse_csv( str, headers: true )
  if headers
    CsvHash.parse( str )
  else
    Csv.parse( str )
  end
end


### note: use read_data / parse_data
##  for alternate shortcut for read_csv / parse_csv w/ headers: false
##       returning arrays of strings
def read_data( path )
  if _download?( path )
    read_data( _wget!( path ).text )
  else
    Csv.read( path )
  end
end

def parse_data( str )
  Csv.parse( str )
end



def read_tab( path )
  if _download?( path )
    parse_tab( _wget!( path ).text )
  else
    Tab.read( path )
  end
end

def parse_tab( str )
  Tab.parse( str )
end


## todo:  add symbolize options ???
def read_json( path )
  JSON.parse( read_text( path ))
end

def parse_json( str )
  JSON.parse( str )
end


### todo/check:  use parse_safeyaml or such? (is default anyway?) - why? why not?
def read_yaml( path )
   YAML.load( read_text( path ))
end

def parse_yaml( str )
  YAML.load( str )
end


def read_ini( path )
   INI.load( read_text( path ))
end

def parse_ini( str )
  INI.load( str )
end

alias_method :read_conf, :read_ini
alias_method :parse_conf, :parse_ini




def read_text( path )
  if _download?( path )
    _wget!( path ).text
  else
   ## todo/check: add universal newline mode or such?
   ##  e.g. will always convert all
   ##    newline variants (\n|\r|\n\r) to "universal" \n only
    txt = File.open( path, 'r:utf-8' ) do |f|
                f.read
          end
    txt
  end
end
alias_method :read_txt, :read_text


def read_blob( path )
  if _download?( path )
    _wget!( path ).blob
  else
    blob =  File.open( path, 'rb' ) do |f|
                   f.read
            end
    blob
  end
end
alias_method :read_binary, :read_blob
alias_method :read_bin,    :read_blob




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




######
#  add writers

def write_json( path, data )
  ###
  ## todo/check:  check if data is Webclient.Response?
  ##   if yes use res.json  - why? why not?

  dirname = File.dirname( path )
  FileUtils.mkdir_p( dirname )  unless Dir.exist?( dirname )

  ## note: pretty print/reformat json
  File.open( path, "w:utf-8" ) do |f|
     f.write( JSON.pretty_generate( data ))
  end
end


def write_blob( path, blob )
  ###
  ## todo/check:  check if data is Webclient.Response?
  ##   if yes use res.blob/body  - why? why not?

  dirname = File.dirname( path )
  FileUtils.mkdir_p( dirname )  unless Dir.exist?( dirname )

  File.open( path, "wb" ) do |f|
    f.write( blob )
  end
end
alias_method :write_binary, :write_blob
alias_method :write_bin,    :write_blob


def write_text( path, text )
  ###
  ## todo/check:  check if data is Webclient.Response?
  ##   if yes use res.text  - why? why not?

  dirname = File.dirname( path )
  FileUtils.mkdir_p( dirname )  unless Dir.exist?( dirname )

  File.open( path, "w:utf-8" ) do |f|
    f.write( text )
  end
end
alias_method :write_txt,  :write_text



######
#   world wide web (www) support

def wget( url, **kwargs )
  Webclient.get( url, **kwargs )
end
##  add alias www_get or web_get - why? why not?



## private helper - make public -why? why not?
def _wget!( url, **kwargs )
  res = Webclient.get( url, **kwargs )

  ##  check/todo - use a different exception/error - keep RuntimeError - why? why not?
  raise RuntimeError, "HTTP #{res.status.code} - #{res.status.message}"   if res.status.nok?

  res
end


end # module Kernel





####
#  convenience alias  (use plural or singual)
Coco = Cocos


puts Cocos.banner   ## say hello

