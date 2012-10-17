require 'helper'

class TestParseStellarDatabase < Test::Unit::TestCase
  should "parse sol ok" do
    p = Stellar::Parser.new 'fixtures/sol.html'
    h = p.parse
    if h["name"] != 'Sol'
      flunk "Sol shouldn't be named #{h["name"]}"
    end
  end
  should "parse alpha centauri" do
    p = Stellar::Parser.new 'fixtures/alpha-centauri.html'
    h = p.parse
    if h["name"] != 'Alpha and Proxima Centauri'
      flunk "Shouldn't be named #{h["name"]}"
    end
  end
end
