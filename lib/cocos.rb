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


class Kernel



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
    txt = File.open( path, 'r:utf-8' ) do |f|
                f.read
          end
    txt
end
alias_method :read_txt, :read_text


def read_lines( path )
    lines = File.open( path, 'r:utf-8' ) do |f|
               f.readlines
            end
    lines
end


end # class Kernel







####
#  convenience alias  (use plural or singual)
Coco = Cocos


puts Cocos.banner   ## say hello

