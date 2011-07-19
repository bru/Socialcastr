class String
  def contains_dot?
     self =~ /\./
  end

  def all_spaces?
    self.gsub(/^[\s\n\t]*$/m, '').empty?
  end
end

class Array
  def to_hash
    self.reduce({}) { |h,kv| h[kv[0]] = kv[1]; h }
  end
end

module Socialcastr
  module SAX

    class ActiveResource < Nokogiri::XML::SAX::Document
      attr_accessor :data
      HASH    = "hash"
      ARRAY   = "array"
      INTEGER = "integer"
      BOOLEAN = "boolean"
      STRING  = "string"

      def initialize
        @types = []
        @values = []
        @data= nil
      end

      def cdata_block(s)
        characters(s)
      end

      def start_element name, attrs = []
        return nil_element! if name.contains_dot? # [FIXME] we can't evaluate strings inside elements like <html.title>
        type = parse_attrs_and_get_type(attrs)
        return if nil_element?
        push_element(type)
      end

      def characters string
        return if nil_element? || (string.all_spaces? && (container_type != STRING || container_value.nil?))
        update_string_element(string)
      end

      def end_element name
        return end_nil_element if nil_element?

        (value, type) = pop_element
        case type
        when HASH
          element = element_class(name).from_hash(value || {})
        when INTEGER
          element = value.to_i
        when BOOLEAN
          element = value == "true" ? true : false
        when ARRAY
          element = value || []
        else
          element = value
        end

        if container_type
          add_to_container(name, element)
        else # Root Node
          self.data = element
        end
      end

      private

      def element_class(name)
        if RUBY_VERSION < '1.9' 
          Socialcastr.const_get(Socialcastr.to_class_name(name))
        else 
          Socialcastr.const_get(Socialcastr.to_class_name(name), false)
        end
      end

      def container_type
        @types.last
      end

      def container_value
        @values.last
      end

      def nil_element!
        @nil = true 
      end

      def nil_element?
        @nil
      end

      def end_nil_element
        @nil = false
      end

      def parse_attrs_and_get_type(attribute_array=[])
        attributes = attribute_array.to_hash
        return nil_element! if attributes["nil"]
        attributes["type"] ? attributes["type"] : HASH
      end

      def push_element(type)
        @types.push type
        @values.push nil
      end

      def pop_element
        return [@values.pop, @types.pop]
      end

      def update_string_element(string)
        @types[-1]  = STRING if container_type == HASH
        @values[-1] = container_value ? container_value + string : string 
      end

      def add_to_container(name, element)
        if container_type == ARRAY
          container_value ? @values[-1].push(element) : @values[-1] = [element]
        else # Hash
          container_value ? @values[-1][name]=element : @values[-1] = { name => element }
        end
      end

    end
  end
end
