require 'hoe'
require './lib/dbbrowser/version.rb'

Hoe.spec 'dbbrowser' do

  self.version = DbBrowser::VERSION

  self.summary = 'dbbrowser - database browser (connections, schema, tables, records, etc.) as mountable web app'
  self.description = summary

  self.urls    = ['https://github.com/rubylibs/dbbrowser']

  self.author  = 'Gerald Bauer'
  self.email   = 'webslideshow@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'History.md'

  self.extra_deps = [
    ['logutils', '>= 0.5']
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 1.9.2'
  }


end