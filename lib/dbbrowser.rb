

require 'dbbrowser/version'  # let it always go first


module DbBrowser

  def self.banner
    "dbbrowser #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

=begin
  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end
=end

end  # module DbBrowser


puts DbBrowser.banner    # say hello

