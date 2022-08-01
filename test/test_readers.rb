###
#  to run use
#     ruby -I ./lib -I ./test test/test_readers.rb


require 'helper'


class TestReaders < MiniTest::Test

MANIFEST_TXT =<<TXT
CHANGELOG.md
LICENSE.md
Manifest.txt
README.md
Rakefile
lib/cocos.rb
lib/cocos/version.rb
TXT

def test_txt
   assert_equal MANIFEST_TXT, read_txt( "./test/data/manifest.txt" )
   assert_equal MANIFEST_TXT, read_text( "./test/data/manifest.txt" )
end

MANIFEST_LINES = [
  "CHANGELOG.md\n",
  "LICENSE.md\n",
  "Manifest.txt\n",
  "README.md\n",
  "Rakefile\n",
  "lib/cocos.rb\n",
  "lib/cocos/version.rb\n",
]

def test_lines
  assert_equal MANIFEST_LINES, read_lines( "./test/data/manifest.txt" )
end


BEER_ARY = [
  ['Andechser Klosterbrauerei','Andechs','Doppelbock Dunkel','7%'],
  ['Augustiner Bräu München','München','Edelstoff','5.6%'],
  ['Bayerische Staatsbrauerei Weihenstephan','Freising','Hefe Weissbier','5.4%'],
  ['Brauerei Spezial','Bamberg','Rauchbier Märzen','5.1%'],
  ['Hacker-Pschorr Bräu','München','Münchner Dunkel','5.0%'],
  ['Staatliches Hofbräuhaus München','München','Hofbräu Oktoberfestbier','6.3%'],
]

BEER_HASH = [
 {"Brewery"=>"Andechser Klosterbrauerei",
   "City"=>"Andechs",
   "Name"=>"Doppelbock Dunkel",
   "Abv"=>"7%"},
 {"Brewery"=>"Augustiner Bräu München",
  "City"=>"München",
  "Name"=>"Edelstoff",
  "Abv"=>"5.6%"},
 {"Brewery"=>"Bayerische Staatsbrauerei Weihenstephan",
   "City"=>"Freising",
   "Name"=>"Hefe Weissbier",
   "Abv"=>"5.4%"},
 {"Brewery"=>"Brauerei Spezial",
   "City"=>"Bamberg",
   "Name"=>"Rauchbier Märzen",
   "Abv"=>"5.1%"},
 {"Brewery"=>"Hacker-Pschorr Bräu",
   "City"=>"München",
   "Name"=>"Münchner Dunkel",
   "Abv"=>"5.0%"},
 {"Brewery"=>"Staatliches Hofbräuhaus München",
   "City"=>"München",
   "Name"=>"Hofbräu Oktoberfestbier",
   "Abv"=>"6.3%"}]

def test_csv
  assert_equal BEER_ARY, read_csv( "./test/data/beer.a.csv", headers: false )
  assert_equal BEER_HASH, read_csv( "./test/data/beer.csv" )

  assert_equal BEER_ARY, parse_csv( <<TXT, headers: false )
Andechser Klosterbrauerei,Andechs,Doppelbock Dunkel,7%
Augustiner Bräu München,München,Edelstoff,5.6%
Bayerische Staatsbrauerei Weihenstephan,Freising,Hefe Weissbier,5.4%
Brauerei Spezial,Bamberg,Rauchbier Märzen,5.1%
Hacker-Pschorr Bräu,München,Münchner Dunkel,5.0%
Staatliches Hofbräuhaus München,München,Hofbräu Oktoberfestbier,6.3%
TXT

  assert_equal BEER_HASH, parse_csv( <<TXT )
Brewery,City,Name,Abv
Andechser Klosterbrauerei,Andechs,Doppelbock Dunkel,7%
Augustiner Bräu München,München,Edelstoff,5.6%
Bayerische Staatsbrauerei Weihenstephan,Freising,Hefe Weissbier,5.4%
Brauerei Spezial,Bamberg,Rauchbier Märzen,5.1%
Hacker-Pschorr Bräu,München,Münchner Dunkel,5.0%
Staatliches Hofbräuhaus München,München,Hofbräu Oktoberfestbier,6.3%
TXT
end



TEST_ARY = [
  ["a", "b", "c"],
  ["1", "2", "3"],
  ["4", "5", "6"]
]

def test_tab
  assert_equal TEST_ARY, read_tab( "./test/data/test.tab" )

  ## note: CANNOT use "natural tab" in text (because editor will AUTOREPLACE
  ##        tabs to space on saving!!)
  assert_equal TEST_ARY, parse_tab( <<TXT )
a\tb\tc
1\t2\t3
4\t5\t6
TXT
end




MARILYN_HASH = { "attributes"=> [
     {"name"=>"Hair",       "value"=>"Wild Blonde"},
     {"name"=>"Blemish",    "value"=>"Mole"},
     {"name"=>"Expression", "value"=>"Smile"}]}

def test_json
  assert_equal MARILYN_HASH, read_json( "./test/data/marilyn.json" )
  assert_equal MARILYN_HASH, parse_json( <<TXT )
{
  "attributes": [
     {"name": "Hair", "value": "Wild Blonde"},
     {"name": "Blemish", "value": "Mole"},
     {"name": "Expression", "value": "Smile"}
  ]
}
TXT
end

def test_yaml
  assert_equal MARILYN_HASH, read_yaml( "./test/data/marilyn.yaml" )
  assert_equal MARILYN_HASH, parse_yaml( <<TXT )
attributes:
  - name:  Hair
    value: Wild Blonde
  - name:  Blemish
    value: Mole
  - name:  Expression
    value: Smile
TXT
end

PLANET_HASH = {
  "title"=>"Planet Open Data News",
  "osm"=> {"title"=>"Open Street Map (OSM) News",
           "link"=>"https://blog.openstreetmap.org",
           "feed"=>"https://blog.openstreetmap.org/feed/"}}

def test_ini
   assert_equal PLANET_HASH, read_ini( "./test/data/planet.ini" )
   assert_equal PLANET_HASH, parse_ini( <<TXT )
title = Planet Open Data News

[osm]
  title = Open Street Map (OSM) News
  link  = https://blog.openstreetmap.org
  feed  = https://blog.openstreetmap.org/feed/
TXT

assert_equal PLANET_HASH, read_conf( "./test/data/planet.ini" )
assert_equal PLANET_HASH, parse_conf( <<TXT )
title = Planet Open Data News

[osm]
title = Open Street Map (OSM) News
link  = https://blog.openstreetmap.org
feed  = https://blog.openstreetmap.org/feed/
TXT
end


end # class TestReaders
