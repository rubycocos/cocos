
module Mono
module Module
module Monofile

  MAJOR = 0    ## todo: namespace inside version or something - why? why not??
  MINOR = 2
  PATCH = 0
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "monofile/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  ## note: move root to its own namespace to avoid
  ##   conflict with Mono.root!!!!
  def self.root
    File.expand_path( File.dirname(File.dirname(__FILE__) ))
  end

end # module Monofile
end # module Module
end # module Mono

