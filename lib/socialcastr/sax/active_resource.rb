module Socialcastr
  module SAX
    class ActiveResource < Nokogiri::XML::SAX::Document
      attr_accessor :data
      def initialize
        @types = []
        @values = []
        @data= nil
      end

      def cdata_block(s)
        characters(s)
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
        if name =~ /\./
          @nil = true
          return nil
        end
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
        return if @nil 
        return if (s =~ /^[\s\n\t]*$/ && (@types[-1] != "string" || @values[-1].empty?))
        @types[-1]  = "string"
        @values[-1] = @values[-1].empty? ? s : @values[-1] + s 
      end

      def end_element name
        @debug = false
        if @nil
          @nil = false
        else
          value = @values.pop
          type = @types.pop
          return if value.empty?

          if type == "hash"
            element = Socialcastr.const_get(Socialcastr.element_class_name(name)).new
            element.instance_variable_set("@data", value)
          else
            element = value
          end

          if @values[-1] 
            if @types[-1] == "array"
              @values[-1].push element
            else
              @values[-1][name] = element
            end
          else
            @data = element
          end
        end
      end
    end
  end
end
