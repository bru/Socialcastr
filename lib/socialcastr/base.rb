require 'sax-machine'

module Socialcastr
  class Base 
    include SAXMachine 

    def initialize(arguments={})
      arguments.map do |k,v|
        self.send((k.to_s + "=").to_sym, v)
      end
    end

    def id
      begin
        tmp_id = send self.class.id_attribute
        tmp_id.to_i unless tmp_id.nil?
      rescue
        nil
      end
    end

    def save
      new? ? create : update
    end

    def create
        api.post(collection_path, to_params).tap do |xml|
          copy_attributes_from_object(self.class.parse(xml))
        end
    end

    def update
        api.put(element_path, to_params).tap do |xml|
          copy_attributes_from_object(self.class.parse(xml))
        end
    end
    
    def copy_attributes_from_object(object=nil)
      object.instance_variables.each do |v|
        instance_variable_set(v, object.instance_variable_get(v))
      end
    end

    def new?
      id.nil?
    end

    def api
      self.class.api
    end

    def element_path
      self.class.element_path(self.id)
    end

    def collection_path
      self.class.collection_path
    end

    def to_params
      params = {}
      instance_variables.each do |variable| 
        params[param_name(variable)] = instance_variable_get(variable)
      end
      params
    end

    def param_name(variable_name)
      "#{self.class.model_name.downcase}[#{variable_name.to_s.gsub /@/,''}]"
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
        (prefix_options, query_options) = parse_options(options)
        path = element_path(id, prefix_options)
        parse(api.get(path, query_options))
      end

      def find_every(options)
        (prefix_options, query_options) = parse_options(options)
        path = collection_path(prefix_options)
        parse_collection(api.get(path, query_options))
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
        "#{collection_path(prefix_options)}/#{URI.escape id.to_s}"
      end

      def collection_path(options = {})
        "#{prefix(options)}#{collection_name}"
      end

      def prefix(options)
        options.map { |k,v| k.to_s.gsub("_id", 's') + "/" + v.to_s }.join("/") + "/"
      end

      def parse_options(options)
        prefix_options = {}
        options.each_pair do |k,v|
          if k.to_s.match(/_id$/)
            prefix_options[k] = v
            options.delete(k)
          end
        end
        return [prefix_options, options]
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
