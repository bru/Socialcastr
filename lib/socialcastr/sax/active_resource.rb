class Boolean
  def initialize(string)
    return true if string == "true"
    return false
  end
end

class String
  def contains_dot?
     self =~ /\./
  end

  def all_spaces?
    self.gsub(/^[\s\n\t]*$/m, '').empty?
  end
end

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

      HASH = 104      # 'h'
      ARRAY = 97      # 'a'
      INTEGER = 105   # 'i'
      BOOLEAN = 98    # 'b'
      STRING = 115    # 's'

      def container_type
        @types[-1]
      end

      def container_value
        @values[-1]
      end

      def parse_attrs_and_get_type(attrs=[])
        type = HASH
        attrs.each do |attr|
          case attr[0]
          when "type"
            type = attr[1][0]
          when "nil"
            @nil = true
          end
        end
        return type
      end

      def start_element name, attrs = []
        if name.contains_dot? # [FIXME] we can't evaluate strings inside elements like <html.title>
          @nil = true 
          return nil
        end
        type = parse_attrs_and_get_type(attrs)
        unless @nil
          @types.push type
          @values.push nil
        end
      end

      def characters string
        return if @nil 
        return if (string.all_spaces? && (container_type != STRING || container_value.nil?))
        @types[-1]  = STRING if container_type == HASH
        @values[-1] = container_value ? container_value + string : string 
      end

      def end_element name
        if @nil
          @nil = false
        else
          value = @values.pop
          type = @types.pop

          # return if value.nil?

          case type
          when HASH
            element = Socialcastr.const_get(Socialcastr.to_class_name(name)).from_hash(value || {})
          when INTEGER
            element = value.to_i
          when BOOLEAN
            element = Boolean.new(value)
          when ARRAY
            element = value || []
          else
            element = value
          end

          if container_type
            if container_type == ARRAY
              @values[-1] ? @values[-1].push(element) : @values[-1] = [element]
            else # Hash
              @values[-1] ? @values[-1][name]=element : @values[-1] = { name => element }
            end
          else # Root Node
            @data = element
          end
        end
      end
    end
  end
end
