# monofile - read in / parse monorepo / mono source tree definitions - a list of git (and github) projects, and more

* home  :: [github.com/rubycoco/monos](https://github.com/rubycoco/monos)
* bugs  :: [github.com/rubycoco/monos/issues](https://github.com/rubycoco/monos/issues)
* gem   :: [rubygems.org/gems/monofile](https://rubygems.org/gems/monofile)
* rdoc  :: [rubydoc.info/gems/monofile](http://rubydoc.info/gems/monofile)



## Usage


Use `Monofile.read` to read in / parse monorepo / mono source tree definitions - supporting a ruby or a yaml format.


Example - `Monofile`:
``` ruby
project "@openfootball/england"
project "@openfootball/world-cup"
project "@geraldb/austria"
project "@geraldb/geraldb.github.io"

project "geraldb", "catalog"
project "openfootball", "europe"
project "openfootball", "south-america"
```

or

Example - `monofile.yml`:

``` yaml
geraldb:
- austria
- catalog
- geraldb.github.io

openfootball:
- england
- europe
- south-america
- world-cup
```


To read use.

``` ruby
monofile = Monofile.read( "./Monofile" )
# -or-
monofile = Monofile.read( "./monofile.yml" )
pp monofile.to_a
#=> ["@openfootball/england",
#    "@openfootball/world-cup",
#    "@geraldb/austria",
#    "@geraldb/geraldb.github.io",
#    "@geraldb/catalog",
#    "@openfootball/europe"]
#    "@openfootball/south-america"]

pp monofile.to_h
#=> {"openfootball"=>["england", "world-cup", "europe", "south-america"],
#    "geraldb"     =>["austria", "geraldb.github.io", "catalog"]}

monofile.each do |proj|
  puts "  #{proj}"
end
#=> @openfootball/england
#   @openfootball/world-cup
#   @geraldb/austria
#   @geraldb/geraldb.github.io
#   @geraldb/catalog
#   @openfootball/europe
#   @openfootball/south-america

monofile.size
#=> 7
```

and so on.  That's it for now.



### Troubleshooting / Debugging

Use the `monofile` command line tool to test reading in of
monorepo / mono source tree definitions.
Example:

```  shell
# option 1) try to find default name (e.g. Monofile, Monofile.rb, etc.)
$ monofile

# option 2) pass in monofiles
$ monofile ./Monofile
$ monofile ./monfile.yml
# ...
```

Printing the normalized / canonical names of the repo sources. Example.

```
@openfootball/england
@openfootball/world-cup
@geraldb/austria
@geraldb/geraldb.github.io
@geraldb/catalog
@openfootball/europe
@openfootball/south-america
```




## Real-World Usage

See the [`monos`](https://github.com/rubycoco/monos/tree/master/monos) package that incl. the `mono` (or short `mo`)
command line tool lets you run
git commands on multiple repo(sitories) with a single command.


## Installation

Use

    gem install monofile

or add to your Gemfile

    gem 'monofile'



## License

The `monofile` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

