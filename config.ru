
### note: for local testing - add to load path dbbrowser/lib

$LOAD_PATH << './lib'

require 'dbbrowser'


ActiveRecord::Base.configurations['pluto'] = {
  adapter:  'sqlite3',
  database: './pluto.db'
}

### see
## http://idevone.wordpress.com/2010/09/26/multiple-activerecord-connections-without-rails/


run DbBrowser::Server
