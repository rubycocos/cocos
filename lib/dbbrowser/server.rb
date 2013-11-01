

# 3rd party libs/gems

require 'sinatra/base'


module DbBrowser

class Server < Sinatra::Base

  def self.banner
    "dbbrowser/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] on Sinatra/#{Sinatra::VERSION} (#{ENV['RACK_ENV']})"
  end

  PUBLIC_FOLDER = "#{DbBrowser.root}/lib/dbbrowser/public"
  VIEWS_FOLDER = "#{DbBrowser.root}/lib/dbbrowser/views"

  puts "[boot] dbbrowser - setting public folder to: #{PUBLIC_FOLDER}"
  puts "[boot] dbbrowser - setting views folder to: #{VIEWS_FOLDER}"

  set :public_folder, PUBLIC_FOLDER # set up the static dir (with images/js/css inside)
  set :views, VIEWS_FOLDER # set up the views dir

  set :static, true # set up static file routing


  set :man, ConnectionMan.new

  #################
  # Helpers
  
  include TextUtils::HypertextHelper  # e.g. lets us use link_to, sanitize, etc.

  def path_prefix
    request.script_name   # request.env['SCRIPT_NAME']
  end

  def db_path( key )
    "#{path_prefix}/db/#{key}"
  end

  def table_path( table )
    "#{path_prefix}/db/#{table.connection.key}/#{table.name.downcase}"
  end

  def root_path
    "#{path_prefix}/"
  end

  def h( text )
    Rack::Utils.escape_html(text)
  end

  def render_spec_for( key, opts={} )
    # render connection spec(ification) aka configuration
    spec = ActiveRecord::Base.configurations[ key ]
    erb( 'shared/_spec'.to_sym,
         layout: false,
         locals: { spec: spec })
  end

  def render_table_def( table, opts={} )
    erb( 'shared/_table_def'.to_sym,
         layout: false,
         locals: { table: table } )
  end

  def render_tables( tables, opts={} )
    erb( 'shared/_tables'.to_sym,
         layout: false,
         locals: { tables: tables } )
  end

  def render_tables_for( key, opts={} )
    con = settings.man.connection_for( key )
    erb( 'shared/_tables'.to_sym,
         layout: false,
         locals: { tables: con.tables } )
  end


  ##############################################
  # Controllers / Routing / Request Handlers


  ### auto-add DATABASE_URL if ar configuration is empty hash ({})
  before do
    if ActiveRecord::Base.configurations.nil?   # -- needed? can this ever happen?
      puts "ActiveRecord configurations nil - set to empty hash"
      ActiveRecord::Base.configurations = {} # make it an empty hash
    end

    if ActiveRecord::Base.configurations.empty?
      puts "ActiveRecord configurations empty? - check for DATABASE_URL in env"   
      DbBrowser.add_database_url 
    end
  end


  get '/' do
    erb :index
  end

  get '/db/:key/:table_name' do |key,table_name|
    con   = settings.man.connection_for( key )
    table  = con.table( table_name )

    query_opts = {}
    query_opts[:limit]  = params[:limit]  if params[:limit].present?
    query_opts[:offset] = params[:offset] if params[:offset].present?
    query_opts[:limit]  = params[:l]  if params[:l].present?   # allow l shortcut for limit
    query_opts[:offset] = params[:o] if params[:o].present?    # allow o shortcut for offset
    ## todo: add params[:page] ??? will use default limit and calculate offset e.g limit*page=offset - why? why not??

    result = table.query( query_opts )
    erb :table, locals: { result: result, table: table, tables: con.tables }
  end

  get '/db/:key' do |key|
    con = settings.man.connection_for( key )
    erb :db, locals: { key: key, tables: con.tables, con: con }
  end

  get '/d*' do
    erb :debug
  end


end # class Server
end # module DbBrowser


# say hello
puts DbBrowser::Server.banner
