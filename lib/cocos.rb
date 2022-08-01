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
require 'cocos/version'   # note: let version always go first


####
#  convenience alias  (use plural or singual)
Coco = Cocos


puts Cocos.banner   ## say hello

