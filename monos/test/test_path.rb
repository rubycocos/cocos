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
  ].each do |name|
     puts "#{name} => >#{MonoFile.norm_name( name )}<"

     assert_equal "#{Mono.root}/yorobot/stage/one", Mono.real_path( name )
  end
end

end # class TestPath

