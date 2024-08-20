require 'hoe'
require './lib/cocos/version.rb'


Hoe.spec 'cocos' do

  self.version = Cocos::VERSION

  self.summary = "cocos (code commons) - auto-include quick-starter prelude & prolog"
  self.description = summary

  self.urls = { home: 'https://github.com/rubycocos/cocos' }

  self.author = 'Gerald Bauer'
  self.email = 'gerald.bauer@gmail.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'CHANGELOG.md'

  self.licenses = ['Public Domain']

  self.extra_deps = [
    ['csvreader',      '>= 1.2.5'],
    ['tabreader',      '>= 1.0.1'],
    ['iniparser',      '>= 1.0.1'],
    ['webclient',      '>= 0.2.2'],
  ]

  self.spec_extras = {
    required_ruby_version: '>= 2.2.2'
  }
end
