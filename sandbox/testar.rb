###
# run as
#  ruby sandbox/testar.rb

require 'pp'

require 'active_record'
require 'pluto'



puts 'before ar config'
pp ActiveRecord::Base.configurations

config_key = 'pluto'

ActiveRecord::Base.configurations[ config_key ] = {
  adapter:  'sqlite3',
  database: './pluto.db'
}

puts 'after ar config'
pp ActiveRecord::Base.configurations

ActiveRecord::Base.establish_connection( config_key )

puts "ENV['RACK_ENV']=>#{ENV['RACK_ENV']}<"
puts "ENV['RAILS_ENV']=>#{ENV['RACK_ENV']}<"

include Pluto::Models

Site.order(:id).each do |site|
  pp site
end

puts 'bye'
