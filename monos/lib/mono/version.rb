## note: use a different module/namespace
##   for the gem version info e.g. MonoCore vs Mono

module Mono
module Module
module Tool     ## todo/check: rename to MonoMeta, MonoModule or such - why? why not?

  MAJOR = 1    ## todo: namespace inside version or something - why? why not??
  MINOR = 0
  PATCH = 2
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "monos/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  ## note: move root to its own namespace to avoid
  ##   conflict with Mono.root!!!!
  def self.root
    File.expand_path( File.dirname(File.dirname(__FILE__) ))
  end

end # module Tool
end # module Module
end # module Mono

##################################
# add a convenience shortcut for now - why? why not?
module Mono
  VERSION = Mono::Module::Tool::VERSION
end

