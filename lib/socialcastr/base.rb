require 'nokogiri'
require 'socialcastr/sax/active_resource'
module Socialcastr
  class Base 
    attr_accessor :prefix_options
    def initialize(arguments={}, prefix_options={})
      @data = {}
      arguments.each_pair do |k,v|
        @data[k.to_s] = v
      end
      @prefix_options = prefix_options
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

    def refresh
      api.get(element_path).tap do |xml|
        copy_attributes_from_object(self.class.parse(xml))
      end
      return self
    end

    def destroy
      api.delete(element_path)
      return self
    end
    
    def copy_attributes_from_object(object=nil)
      @data = object.instance_variable_get("@data")
      return self
    end

    def new?
      id.nil?
    end

    def api
      @api ||= self.class.api
    end

    def element_path
      self.class.element_path(self.id, @prefix_options)
    end

    def collection_path
      self.class.collection_path(@prefix_options)
    end

    def to_params
      params = {}
      @data.each_pair do |k,v| 
        params[param_name(k)] = v
      end
      params
    end

    def to_prefix_options
      @prefix_options.merge "#{self.class.model_name.downcase}_id" => id
    end

    def param_name(variable_name)
      "#{self.class.model_name.downcase}[#{variable_name}]"
    end

    def method_name(s)
      s.to_s.gsub("_","-")
    end

    def id
      return @data["id"]
    end

    def method_missing(method, *args, &block)
      if method.to_s =~ /=$/
        @data[method_name(method.to_s.sub(/=$/,''))] = args.first
      else
        obj = @data[method_name(method)] 
        return nil unless obj
        unless new?
          self.class.set_prefix_options(obj, to_prefix_options)
        end
        return obj
      end
    end

    class << self
      def parse(xml="", prefix_options={})
        resource = SAX::ActiveResource.new
        Nokogiri::XML::SAX::Parser.new(resource).parse(xml)
        return set_prefix_options(resource.data, prefix_options)
      end

      def set_prefix_options(obj, prefix_options={})
        if obj.class.ancestors.include? Socialcastr::Base
          obj.prefix_options = prefix_options
          return obj
        end
        if obj.class == Array
          obj.each do |o|
            set_prefix_options(o, prefix_options)
          end
        end
      end

      def from_hash(h)
        new.tap { |object| object.instance_variable_set("@data", h) }
      end

      def api
        Socialcastr.api
      end

      def find(*arguments)
        args = arguments.dup
        scope = args.slice!(0)
        options = args.slice!(0) || {}
        case scope
          when :all   then find_every(options)
          when :first then find_every(options).first
          when :last  then find_every(options).to_a.last
          else             find_single(scope, options)
        end
      end

      def find_single(id, options)
        (prefix_options, query_options) = parse_options(options)
        path = element_path(id, prefix_options)
        parse(api.get(path, query_options), prefix_options)
      end

      def find_every(options)
        (prefix_options, query_options) = parse_options(options)
        path = collection_path(prefix_options)
        parse(api.get(path, query_options), prefix_options)
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
    end
  end
end
