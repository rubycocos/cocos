# cocos (code commons) - auto-incude quick-starter prelude & prolog


* home  :: [github.com/rubycocos/cococs](https://github.com/rubycocos/cococs)
* bugs  :: [github.com/rubycocos/cococs/issues](https://github.com/rubycocos/cococs/issues)
* gem   :: [rubygems.org/gems/cocos](https://rubygems.org/gems/cocos)
* rdoc  :: [rubydoc.info/gems/cocos](http://rubydoc.info/gems/cocos)



## Intro - Why?


**Reason No. 1**

After starting of too many scripts (hundreds?) with
adding more and always repeating the same dozen modules with require e.g.:

``` ruby
require 'pp'
require 'time'
require 'date'
require 'json'
require 'yaml'
require 'fileutils'

require 'uri'
require 'net/http'
require 'net/https'

...
```

why not use a more "inclusive" prelude & prolog and
replace the above with a one-liner:

``` ruby
require 'cocos' # auto-include code commons quick-starter prelude & prolog
```


**Reason No. 2**

After reading too many text files in utf-8 and always repeating the same open / read and code block dance e.g.:

``` ruby
txt = File.read( "history.txt" )
# sorry - will NOT guarantee unicode utf8-encoding
# (e.g. on microsoft windows it is ISO Code Page (CP-1252
# or something - depending on your locale/culture/language)

txt = File.open( "history.txt", "r:utf-8" ) do |f|
             f.read
         end
```

Or after reading and parsing too many json files
(by default always required utf-8 encoding)
and always repeating the same open / read and code block dance
again and again e.g.:

``` ruby
txt  = File.open( "history.json", "r:utf-8" ) do |f|
             f.read
         end
data = JSON.parse( txt )
```

Why not use read convenience / short-cut helpers such as:

``` ruby
txt  = read_txt( "history.txt" )
data = read_json( "history.json" )
```


And so on.





## Usage

###  Read / Parse

_Read / parse convenience short-cut helpers_


`read_text( path )` <br>
also known as `read_txt`


`read_lines( path )`


`read_json( path )` / `parse_json( str )`


`read_yaml( path )` / `parse_yaml( str )`


`read_csv( path, headers: true )` / `parse_csv( str, headers: true )`

note: comma-separated values (.csv) reading & parsing service
brought to you by the [**csvreader library / gem »**](https://github.com/rubycocos/csvreader/tree/master/csvreader)


`read_tab( path )` / `parse_tab( str )`

note: tabulator (`\t`)-separated values (.tab) reading & parsing service
brought to you by the [**tabreader library / gem »**](https://github.com/rubycocos/csvreader/tree/master/tabreader)




`read_ini( path )` / `parse_ini( str )` <br>
also known as `read_conf / parse_conf`

note: ini / conf(ig) reading & parsing service
brought to you by the [**iniparser library / gem »**](https://github.com/rubycocos/core/tree/master/iniparser)



That's it for now.



## License

The `cocos` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

