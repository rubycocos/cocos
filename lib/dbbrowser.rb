
require 'pp'


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


  ### helper for DATABASE_URL for ActiveRecord

  def self.add_database_url

    str = ENV['DATABASE_URL']
    if str.blank?
      puts "no ENV['DATABASE_URL'] found; skip adding DATABASE_URL config"
      return
    end
  
    ####
    # check/fix/todo:
    # for config key (use env for now)
    # use RACK_ENV or RAILS_ENV if present?? why? why not?
    # only if not already in config? possible?

    db = URI.parse( str )

    ### use spec instead of config ???

    if db.scheme == 'postgres'
      config = {
        adapter: 'postgresql',
        host: db.host,
        port: db.port,
        username: db.user,
        password: db.password,
        database: db.path[1..-1],
        encoding: 'utf8'
      }
    else  # assume sqlite for now
      config = {
        adapter: db.scheme, # sqlite3
        database: db.path[1..-1] # pluto.db (NB: cut off leading /, thus 1..-1)
      }
    end

    puts 'db settings:'
    pp config

    if ActiveRecord::Base.configurations.nil?
      puts "ActiveRecord configurations nil - set to empty hash"
      ActiveRecord::Base.configurations = {} # make it an empty hash
    end

    puts 'ar configurations (before):'
    pp ActiveRecord::Base.configurations

    ActiveRecord::Base.configurations['env'] = config

    puts 'ar configurations (after):'
    pp ActiveRecord::Base.configurations
  end


end  # module DbBrowser


require 'dbbrowser/server'
