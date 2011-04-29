require 'sax-machine'

module Socialcastr
  class Base 
    include SAXMachine 

    def id
      (send self.class.id_attribute).to_i
    end

    class << self
      def api
        @api ||= Socialcastr.api
      end

      def find(*arguments)
        scope = arguments.slice!(0)
        options = arguments.slice!(0) || {}
        case scope
          when :all   then find_every(options)
          when :first then find_every(options).first
          when :last  then find_every(options).to_a.last
          #when :one   then find_one(options)
          else             find_single(scope, options)
        end
      end

      def find_single(id, options)
        path = element_path(id, options)
        parse(api.get(path))
      end

      def find_every(options)
        path = collection_path(options)
        parse_collection(api.get(path))
      end

      def all(*arguments)
        find(:all, *arguments)
      end

      def first(*arguments)
        find(:first, *arguments)
      end

      def last(*arguments)
        find(:last, *arguments)
      end

      def element_path(id, prefix_options = {})
        "#{prefix(prefix_options)}#{collection_name}/#{URI.escape id.to_s}"
      end

      def collection_path(options = {})
        "#{prefix(options)}#{collection_name}"
      end

      def prefix(options)
        options.map { |k,v| k.to_s.gsub("_id", 's') + "/" + v.to_s }.join("/") + "/"
      end

      def model_name
        self.to_s.gsub(/^.*::/, '')
      end

      def collection_name
        model_name.downcase + "s"
      end

      def parse_collection(data)
        collection_class.parse(data)
      end

      def id_attribute
        model_name.downcase + "_id"
      end

      def collection_class
        return @collection_class if @collection_class
        class_name = model_name + "List"
        model_class = self
        c_element = model_name.downcase.to_sym
        c_name = collection_name.to_sym
        klass = Object.const_set(class_name,Class.new(Socialcastr::Collection))
        klass.class_eval do
          collection_of c_element, :as => c_name, :class => model_class
        end
        return @collection_class = klass
      end

      def id_element(name=:id)
        element name, :as => id_attribute.to_sym
      end
    end
  end
end
