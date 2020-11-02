###
#  to run use
#     ruby -I ./lib -I ./test test/test_path.rb

require 'helper'

class TestPath < MiniTest::Test


def test_real_path
  [
    '@yorobot/stage/one',
    'one@yorobot/stage',
    'stage/one@yorobot',
  ].each do |path|
     puts "#{path} => >#{Monopath.parse( path )}<"

     assert_equal "#{Mono.root}/yorobot/stage/one", Monopath.real_path( path )
  end
end

end # class TestPath

