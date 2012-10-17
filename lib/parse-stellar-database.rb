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
      subsection = nil
      h["name"] = @doc.css("h1").first.content
      @doc.css("body b").each do |line|
        if u = line.css("u").first
          subsection = u.content.strip.to_key_name
          h[subsection] = {}
        end
        k = line.content.strip.to_key_name
        v = next_greedy line
        if !v
          return
        end
        if subsection
          if !u
            h[subsection][k] = v
          end
        else
          h[k]=v
        end
      end
      return rewrite h
    end

    def next_greedy(line)
      output = ''
      while line.next_sibling and ['br','text','a','i'].include? line.next_sibling.name
        line = line.next_sibling
        output += " " + line.content.strip
      end
      output.gsub(/ +/,' ').gsub(/[^\x00-\x7f]/,'').strip
    end

    def rewrite(input)
      output = {}
      companions={}
      input.each do |k,v|
        if v.is_a? Hash
          v = rewrite(v)
        end
        if k=~ /^companion_/
          k = k.sub /^companion_/, ''
          companions[k] = v
        elsif k =~ /names$/
        else
          output[k]=coords k, v
        end
      end
      output['companions']=companions
      return output
    end

    def coords(k, v)
      m=k.match /_(\w{3})_(coordinates|velocity)/
      if v.is_a? String
        a=v.split /, */
      end
      if m == nil
        if k =~ /_(names|numbers)$/
          return a
        else
          return v
        end
      end
      Hash[m[1].chars.zip a]
    end

  end

  class Crawler
    def initialize
      @url_base="http://www.stellar-database.com/Scripts/search_star.exe?ID="
      @id_last=224800
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
