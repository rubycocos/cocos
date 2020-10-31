###
#  to run use
#     ruby -I ./lib -I ./test test/test_names.rb


require 'helper'


class TestNames < MiniTest::Test

def test_parse
  %w[
    @yorobot/stage
    stage@yorobot
  ].each do |line|
    mono = Mononame.parse( line )

    assert_equal '@yorobot/stage', mono.to_s
    assert_equal 'yorobot/stage',  mono.to_path

    assert_equal 'yorobot',            mono.org
    assert_equal 'stage',              mono.name
  end


  %w[
    @yorobot/stage/one
    one@yorobot/stage
    stage/one@yorobot
  ].each do |line|
    mono = Monopath.parse( line )

    assert_equal '@yorobot/stage/one', mono.to_s
    assert_equal 'yorobot/stage/one',  mono.to_path

    assert_equal 'yorobot',            mono.org
    assert_equal 'stage',              mono.name
    assert_equal 'one',                mono.path
  end

  %w[
    @yorobot/stage/one/hello.txt
    hello.txt@yorobot/stage/one
    stage/one/hello.txt@yorobot
  ].each do |line|
    mono = Monopath.parse( line )

    assert_equal '@yorobot/stage/one/hello.txt', mono.to_s
    assert_equal 'yorobot/stage/one/hello.txt',  mono.to_path

    assert_equal 'yorobot',            mono.org
    assert_equal 'stage',              mono.name
    assert_equal 'one/hello.txt',      mono.path
  end
end   # method test_parse


def test_init
  mono = Mononame.new( 'yorobot','stage' )

  assert_equal '@yorobot/stage', mono.to_s
  assert_equal 'yorobot/stage',  mono.to_path

  assert_equal 'yorobot',            mono.org
  assert_equal 'stage',              mono.name


  mono = Monopath.new( 'yorobot', 'stage', 'one' )

  assert_equal '@yorobot/stage/one', mono.to_s
  assert_equal 'yorobot/stage/one',  mono.to_path

  assert_equal 'yorobot',            mono.org
  assert_equal 'stage',              mono.name
  assert_equal 'one',                mono.path


  ## !!!!todo/check/fix!!!!!:
  ##   - support 'one', 'hello.txt' too (or only) - why? why not?
  ##
  ##  todo/check/fix:
  ##    find a better name for path/path? component / part - why? why not?
  ##      to_path and path/path? to confusing!!!
  mono = Monopath.new( 'yorobot', 'stage', 'one/hello.txt' )

  assert_equal '@yorobot/stage/one/hello.txt', mono.to_s
  assert_equal 'yorobot/stage/one/hello.txt',  mono.to_path

  assert_equal 'yorobot',            mono.org
  assert_equal 'stage',              mono.name
  assert_equal 'one/hello.txt',      mono.path
end   # method test_init



end # class TestNames
