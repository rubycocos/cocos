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


require 'optparse'    ## used by monofile (built-in test/debug) command line tool


###
# 3rd party gems
require 'csvreader'
require 'tabreader'
require 'iniparser'


#####################
# our own code
require 'cocos/version'   # note: let version always go first


###
##  read/parse convenience/helper shortcuts


module Kernel



## todo:  add symbolize options a la read_json
##         add sep options
def read_csv( path, headers: true )
   if headers
      CsvHash.read( path )
   else
      Csv.read( path )
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
  Csv.read( path )
end

def parse_data( str )
  Csv.parse( str )
end



def read_tab( path )
   Tab.read( path )
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
   ## todo/check: add universal newline mode or such?
   ##  e.g. will always convert all
   ##    newline variants (\n|\r|\n\r) to "universal" \n only
    txt = File.open( path, 'r:utf-8' ) do |f|
                f.read
          end
    txt
end
alias_method :read_txt, :read_text


def read_blob( path )
  blob =  File.open( path, 'rb' ) do |f|
                  f.read
          end
  blob
end
alias_method :read_binary, :read_blob
alias_method :read_bin,    :read_blob




## todo/check: remove \n (or\r or \r\n) from line
##   ruby (by default) keeps the newline - follow tradition? why? why not?
##
def read_lines( path )
    lines = File.open( path, 'r:utf-8' ) do |f|
               f.readlines
            end
    lines
end


end # module Kernel







####
#  convenience alias  (use plural or singual)
Coco = Cocos


puts Cocos.banner   ## say hello

