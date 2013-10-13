
# 3rd party gems/libs

require 'textutils'

require 'active_record'


# our own code

require 'dbbrowser/version'  # let it always go first
require 'dbbrowser/connection'

module DbBrowser

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end

end  # module DbBrowser


require 'dbbrowser/server'
