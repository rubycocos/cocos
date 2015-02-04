# encoding: utf-8

module DbBrowser

  VERSION = '0.2.0'

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
  end

end


