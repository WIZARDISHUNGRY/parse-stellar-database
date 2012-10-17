require 'helper'

class TestParseStellarDatabase < Test::Unit::TestCase
  should "parse a fixture ok" do
    p = Stellar::Parser.new 'fixtures/sol.html'
    h = p.parse
    if h["name"] != 'Sol'
      flunk "Sol shouldn't be named #{h["name"]}"
    end
  end
end
