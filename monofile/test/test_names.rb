###
#  to run use
#     ruby -I ./lib -I ./test test/test_names.rb


require 'helper'


class TestNames < MiniTest::Test

def test_parse
  %w[
    @openfootball/england
    england@openfootball
  ].each do |line|
    mono = Mononame.parse( line )

    assert_equal '@openfootball/england', mono.to_s
    assert_equal 'openfootball/england',  mono.to_path

    assert_equal 'openfootball',          mono.org
    assert_equal 'england',               mono.name
  end


  %w[
    @openfootball/england/2020-21
    2020-21@openfootball/england
    england/2020-21@openfootball
  ].each do |line|
    mono = Monopath.parse( line )

    assert_equal '@openfootball/england/2020-21', mono.to_s
    assert_equal 'openfootball/england/2020-21',  mono.to_path

    assert_equal 'openfootball',            mono.org
    assert_equal 'england',                 mono.name
    assert_equal '2020-21',                 mono.path
  end

  %w[
    @openfootball/england/2020-21/premierleague.txt
    2020-21/premierleague.txt@openfootball/england
    england/2020-21/premierleague.txt@openfootball
  ].each do |line|
    mono = Monopath.parse( line )

    assert_equal '@openfootball/england/2020-21/premierleague.txt', mono.to_s
    assert_equal 'openfootball/england/2020-21/premierleague.txt',  mono.to_path

    assert_equal 'openfootball',              mono.org
    assert_equal 'england',                   mono.name
    assert_equal '2020-21/premierleague.txt', mono.path
  end
end   # method test_parse



def test_init
  mono = Mononame.new( 'openfootball','england' )

  assert_equal '@openfootball/england', mono.to_s
  assert_equal 'openfootball/england',  mono.to_path

  assert_equal 'openfootball',            mono.org
  assert_equal 'england',              mono.name


  mono = Monopath.new( 'openfootball', 'england', '2020-21' )

  assert_equal '@openfootball/england/2020-21', mono.to_s
  assert_equal 'openfootball/england/2020-21',  mono.to_path

  assert_equal 'openfootball',            mono.org
  assert_equal 'england',                 mono.name
  assert_equal '2020-21',                 mono.path


  ## !!!!todo/check/fix!!!!!:
  ##   - support '2020-21', 'premierleague.txt' too (or only) - why? why not?
  ##
  ##  todo/check/fix:
  ##    find a better name for path/path? component / part - why? why not?
  ##      to_path and path/path? to confusing!!!
  mono = Monopath.new( 'openfootball', 'england', '2020-21/premierleague.txt' )

  assert_equal '@openfootball/england/2020-21/premierleague.txt', mono.to_s
  assert_equal 'openfootball/england/2020-21/premierleague.txt',  mono.to_path

  assert_equal 'openfootball',              mono.org
  assert_equal 'england',                   mono.name
  assert_equal '2020-21/premierleague.txt', mono.path
end   # method test_init



end # class TestNames
