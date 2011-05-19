$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require 'socialcastr/exceptions'
require 'socialcastr/base'
require 'socialcastr/collection'
require 'socialcastr/api'
require 'socialcastr/attachment'
require 'socialcastr/avatar_list'
require 'socialcastr/user'
require 'socialcastr/flag'
require 'socialcastr/like'
require 'socialcastr/comment'
require 'socialcastr/group'
require 'socialcastr/group_membership'
require 'socialcastr/stream'
require 'socialcastr/source'
require 'socialcastr/tag'
require 'socialcastr/recipient'
require 'socialcastr/thumbnail_list'
require 'socialcastr/media_file'
require 'socialcastr/external_resource'
require 'socialcastr/message'

require 'singleton'
require 'yaml'

module Socialcastr

  class MissingConfiguration < StandardError; end;

  class Configuration
    include Singleton
    ATTRIBUTES = [:domain, :username, :password, :format, :debug, :config_file]
    attr_accessor *ATTRIBUTES

    def ready?
      (ATTRIBUTES - [:config_file]).map { |a| self.send a }.map(&:nil?).none?
    end

    def format
      @format ||= 'xml'
    end

    def debug
      @debug ||= false
    end

    def reset
      ATTRIBUTES.each do |attribute|
        send(attribute.to_s + "=", nil)
      end
      return self
    end
  end 

  def self.configuration
    if block_given?
      yield Configuration.instance
      if Configuration.instance.config_file
        config = YAML::load_file(Configuration.instance.config_file)
        Configuration.instance.domain   = config['domain']
        Configuration.instance.username = config['username']
        Configuration.instance.password = config['password']
        Configuration.instance.format   = config['format']
        Configuration.instance.debug    = config['debug']
      end 
    end 
    Configuration.instance
  end 

  def self.api
    config = Configuration.instance
    raise MissingConfiguration unless config.username
    API.new(config.username, config.password, config.domain, config.format, config.debug)
  end

  def self.element_class(method)
    class_name = method.to_s.gsub(/^[a-z]|-[a-z]/i) { |a| a.sub("-", '').upcase }
    unless Socialcastr.const_defined?(class_name)
      Socialcastr.const_set(class_name, Class.new(Socialcastr::Base))
    end
    return class_name
  end
  def self.collection_class(method)
    class_name = method.to_s.gsub(/^[a-z]|-[a-z]/i) { |a| a.sub("-", '').upcase }
    unless Socialcastr.const_defined?(class_name)
      Socialcastr.const_set(class_name, Class.new(Socialcastr::Collection))
    end
    return class_name
  end
  
end
