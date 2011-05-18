$:.unshift("./lib")
require "rubygems"
require "nokogiri"

class ActiveResourceXML < Nokogiri::XML::SAX::Document
  attr_accessor :doc
  def initialize
    @types = []
    @values = []
    @doc = nil
  end

  def parse_attrs(attrs=[])
    type = "hash"
    attrs.each do |attr|
      case attr[0]
      when "type"
        type = attr[1]
      when "nil"
        @nil = true
      end
    end
    return type
  end

  def start_element name, attrs = []
    type = parse_attrs(attrs)
    unless @nil
      @types.push type
      case type
      when "array"
        @values.push Array.new
      when "hash"
        @values.push Hash.new
      else 
        @values.push ""
      end
    end
  end

  def characters(s)
    return if s =~ /^[\s\n\t]*$/
    @types[-1] = "string"
    @values[-1] =  s
  end

  def end_element name
    if @nil
      @nil = false
    else
      value = @values.pop
      type = @types.pop

      if @values[-1] 
        if @types[-1] == "array"
          @values[-1].push value
        else
          @values[-1][name] = value
        end
      else
        @doc = { name => value }
      end
    end
  end

end

class Message
  def self.parse(xml="")
    source= ActiveResourceXML.new
    parser = Nokogiri::XML::SAX::Parser.new(source)
    parser.parse(xml)
    return source
  end
end


xml = File.read("/Users/bru/Downloads/socialcast.xml")
start_time = Time.new
document = Message.parse(xml)
end_time = Time.new

puts "File parsed in #{end_time - start_time} seconds"
puts "Found #{document.doc["messages"].size} messages"



