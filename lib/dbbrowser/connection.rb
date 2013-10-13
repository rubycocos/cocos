module DbBrowser

class ConnectionMan  # connection manager
  
  # get connection names
  #  def connection_names
  #    ActiveRecord::Base.configurations.keys
  #  end

  def connection( key='std' )
    if key == 'std'
      # -- use/try 'standard/default' connection
      con = ActiveRecord::Base.connection
    else
      con = AbstractModel.connection_for( key )
    end
    # wrap ActiveRecord connection in our own connection class
    Connection.new( con, key )
  end


  class AbstractModel < ActiveRecord::Base
    self.abstract_class = true   # no table; class just used for getting db connection

    CONNECTS = {}  # cache connections
    def self.connection_for( key )
      CONNECTS[ key ] ||= begin
        establish_connection( key )
        connection
      end
    end
  end # class AbstractModel


  class Connection

    def initialize( connection, key )
      @connection = connection
      @key        = key
    end

    attr_reader  :connection
    attr_reader  :key

    delegate :select_value, :select_all,
             :to => :connection

  #    delegate :quote_table_name, :quote_column_name, :quote,
  #             :update, :insert, :delete,
  #             :add_limit_offset!,
  #             :to => :connection

    def tables
      @tables ||= fetch_table_defs
    end

    def table( name )
      tables.find { |t| t.name.downcase == name.downcase }
    end

    # getting list of column definitions
    # and order them to be more human readable
    def table_columns( name )
      cols = fetch_table_column_defs( name )
      ### fix/to be done
      # cols.sort_by{|col|
      #    [
      #      fields_to_head.index(col.name) || 1e6,
      #      -(fields_to_tail.index(col.name) || 1e6),
      #      col.name
      #    ]
      #  }
      cols
    end

    def fetch_table_defs
      @connection.tables.sort.map do |name|
        Table.new( self, name )
      end
    end

    def fetch_table_column_defs( name )
      ### fix/todo: add reference to table_def
      @connection.columns( name ).map do |col|
        Column.new( col.name, col.sql_type, col.default, col.null )
      end
    end


    def fetch_table_select_all( name, opts={} )
      per_page = (opts[:perpage] || 33).to_i   # 33 records per page (for now default)

      sql = "select * from #{name} limit #{per_page}"

      # page = (opts[:page] || 1 ).try(:to_i)
      # fields = opts[:fields] || nil
     
      # rez = { :fields => fields }
      # if sql =~ /\s*select/i && per_page > 0
      #  rez[:count] = select_value("select count(*) from (#{sql}) as t").to_i
      #  rez[:pages] = (rez[:count].to_f / per_page).ceil
      #  sql = "select * from (#{sql}) as t"
      #  add_limit_offset!( sql,
      #                        :limit => per_page,
      #                        :offset => per_page * (page - 1))
      # end

      result = {}
      result[ :rows ] = select_all( sql )

      #    unless rez[:rows].blank?
      #      rez[:fields] ||= []
      #      rez[:fields].concat( self.sort_fields(rez[:rows].first.keys) - rez[:fields] )
      #    end

      Result.new( result )
    rescue StandardError => ex
      Result.new( error: ex )
    end  # fetch_table


=begin
      def column_names(table)
        columns(table).map{|c| c.name}
      end

      # fields to see first
      def fields_to_head
        @fields_to_head ||= %w{id name login value}
      end

      # fields to see last
      def fields_to_tail
        @fields_to_tail ||= %w{created_at created_on updated_at updated_on}
      end

      attr_writer :fields_to_head, :fields_to_tail

      # sort field names in a rezult
      def sort_fields(fields)
        fields = (fields_to_head & fields) | (fields - fields_to_head)
        fields = (fields - fields_to_tail) | (fields_to_tail & fields)
        fields
      end

      # performs query with appropriate method
      def query(sql, opts={})
        per_page = (opts[:perpage] || nil).to_i
        page = (opts[:page] || 1 ).try(:to_i)
        fields = opts[:fields] || nil
        case sql
        when /\s*select/i , /\s*(update|insert|delete).+returning/im
          rez = {:fields => fields}
          if sql =~ /\s*select/i && per_page > 0
            rez[:count] = select_value("select count(*) from (#{sql}) as t").to_i
            rez[:pages] = (rez[:count].to_f / per_page).ceil
            sql = "select * from (#{sql}) as t"
            add_limit_offset!( sql,
                              :limit => per_page,
                              :offset => per_page * (page - 1))
          end

          rez[:rows] = select_all( sql )

          unless rez[:rows].blank?
            rez[:fields] ||= []
            rez[:fields].concat( self.sort_fields(rez[:rows].first.keys) - rez[:fields] )
          end

          Result.new(rez)
        when /\s*update/i
          Result.new :value => update( sql )
        when /\s*insert/i
          Result.new :value => insert( sql )
        when /\s*delete/i
          Result.new :value => delete( sql )
        end
      rescue StandardError => e
        Result.new :error => e
      end

=end
      
  end # class Connection


  class Table

    def initialize(connection, name)
      @connection = connection
      @name       = name
    end

    attr_reader :connection
    attr_reader :name

    def count
      @connection.select_value( "select count(*) from #{name}").to_i
    end

    def columns
      # load columns on demand for now (cache on first lookup)
      @columns ||= @connection.table_columns( @name )
    end

    def query( opts={})
      @connection.fetch_table_select_all( @name, opts )
    end

  end # class Table


  class Column
    def initialize(name, type, default, null)
      @name    = name
      @type    = type   # note: is sql_type
      @default = default
      @null    = null   # note: true|false depending if NOT NULL or not
    end

    attr_reader :name, :type, :default, :null
  end # class Column


  class Result
    def initialize( opts={} )
      if opts[:error]
        @error = opts[:error]
      else
        @rows = opts[:rows]
        # @count = opts[:count] || @rows.size
        # @pages = opts[:pages] || 1
        # @fields = opts[:fields]
      end
    end

    attr_reader :rows, :error   ### to be done :count, :pages, :fields, 

    def error?()  @error.present?;       end
    def rows?()   @rows != nil;          end
  end # class Result


end # class  ConnectionMan

end # module DbBrowser