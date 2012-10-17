require "rubygems"
require "nokogiri"
require "open-uri"
require "sanitize"

class String
  def to_key_name
    downcase!
    gsub!(' ','_')
    gsub!(/\W/,'')
  end
end

module Stellar

  class Parser
    def initialize(url)
      @doc = Nokogiri::HTML.parse(open url)
    end

    def parse
      h = {}
      h["name"] = @doc.css("h1").first.content
      @doc.css("body > b").each do |line|
        k = line.content.strip.to_key_name
        v = line.next.content.strip
        h[k]=v
      end
      return h
    end
  end

  class Crawler
    def initialize
      @url_base="http://www.stellar-database.com/Scripts/search_star.exe?ID="
      @id_last=224800
      @id_last=200
      @id_first=100
      @id_step=100
    end

    def crawl
      j = {}
      @id_first.step(@id_last,@id_step) do |i|
        h = parse i
        j[h["name"]]=h
      end
      return j
    end

    def parse(id,count=0)
      url = "#{@url_base}#{id}"
      begin
        p = Stellar::Parser.new url
        return p.parse
      rescue Exception => e
        count+=1
        puts e.message
        puts e.backtrace.inspect
        if count <= 5
          sleep (count*count*8)
          return parse(id,count)
        else
          raise e
        end
      end
    end

  end
end
