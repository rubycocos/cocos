###
#  to run use
#     ruby -I ./lib -I ./test test/test_env.rb


require 'helper'


class TestEnv < MiniTest::Test

ENV_TXT =<<TXT
# comment here
abc=123
def = 456
TXT

ENV_HASH = {
  'abc' => '123',
  'def' => '456'
}

def test_env
   assert_equal ENV_HASH, parse_env( ENV_TXT )
end

end # class TestEnv
