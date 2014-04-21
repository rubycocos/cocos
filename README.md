# dbbrowser gem

database browser (connections, schema, tables, records, etc.) as mountable web app

* home  :: [github.com/rubylibs/dbbrowser](https://github.com/rubylibs/dbbrowser)
* bugs  :: [github.com/rubylibs/dbbrowser/issues](https://github.com/rubylibs/dbbrowser/issues)
* gem   :: [rubygems.org/gems/dbbrowser](https://rubygems.org/gems/dbbrowser)
* rdoc  :: [rubydoc.info/gems/dbbrowser](http://rubydoc.info/gems/dbbrowser)

## Usage

### Rack

In your rack configuration (`config.ru`) mount the databrowser app; add the line:

~~~
map('/browse') { run DbBrowser::Server  }
~~~


### Rails

In your routes (`config/routes.rb`) mount the databrowser app; add the line:

~~~
mount DbBrowser::Server, :at => '/browse'
~~~


## Real World Usage

The pluto live feed reader site uses the database browser; see [`pluto.live/config.ru`](https://github.com/feedreader/pluto.live/blob/master/config.ru)

The sport.db.admin site uses the database browser; see [`sport.db.admin/config/routes.rb`](https://github.com/geraldb/sport.db.admin/blob/master/config/routes.rb)



## Alternatives

### Browser

[db_explorer](https://github.com/robinbortlik/db_explorer) by Robin Bortlík; Rails web app

[dbadmin gem](https://rubygems.org/gems/dbadmin) [(Source)](https://github.com/pjb3/dbadmin) by Paul Barry; last update October 2012

[rails_db_browser gem](https://rubygems.org/gems/rails_db_browser) [(Source)](https://github.com/funny-falcon/rails_db_browser) by Sokolov Yura; last update March 2011

[rails_db_admin gem](https://rubygems.org/gems/rails_db_admin) [(Source)](https://github.com/portablemind/compass_agile_enterprise) by Rick Koloski, Russell Holmes; last update June 2013

[databrowser gem](https://rubygems.org/gems/databrowser) by Carlos Junior; last update August 2008



### Admin / ActiveScaffold

- ActiveAdmin
- RailsAdmin


## License

The `dbbrowser` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.
