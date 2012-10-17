require 'helper'

class TestParseStellarDatabase < Test::Unit::TestCase
  should "parse sol ok" do
    p = Stellar::Parser.new 'fixtures/sol.html'
    h = p.parse
    if h["name"] != 'Sol'
      flunk "Sol shouldn't be named #{h["name"]}"
    end
    if h["companions"].size != 8
      flunk "My Very Educated Mother Just Served Us Nachos"
    end
    if not h['points_of_interest'] =~ /Kuiper Belt object/
      flunk "Must have points of interest described"
    end
  end
  should "parse alpha centauri" do
    p = Stellar::Parser.new 'fixtures/alpha-centauri.html'
    h = p.parse
    if h["name"] != 'Alpha and Proxima Centauri'
      flunk "Shouldn't be named #{h["name"]}"
    end
  end
  should "parse cygnus x1" do
    p = Stellar::Parser.new 'fixtures/cygnus-x-1.html'
    h = p.parse
    h=h['components']['b']
    if h["luminosity_class"] != "black hole"
      flunk "Please warn of all black holes :) #{h['luminosity_class']}"
    end
  end
  should "parse Bonner Durchmusterung -143.3093" do
    p = Stellar::Parser.new 'fixtures/bonner-durchmusterun-1.-14.3093.html'
    h = p.parse
    if not h["heavy_element_abundance"] =~ /33/
      flunk "heavy metal check = #{h['heavy_element_abundance']}"
    end
  end
end
