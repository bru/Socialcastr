$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require 'socialcastr/base'
require 'socialcastr/collection'
require 'socialcastr/api'
require 'socialcastr/attachment'
require 'socialcastr/attachment_list'
require 'socialcastr/avatar_list'
require 'socialcastr/user'
require 'socialcastr/user_list'
require 'socialcastr/like'
require 'socialcastr/like_list'
require 'socialcastr/comment'
require 'socialcastr/comment_list'
require 'socialcastr/group'
require 'socialcastr/group_list'
require 'socialcastr/group_membership'
require 'socialcastr/group_membership_list'
require 'socialcastr/stream'
require 'socialcastr/stream_list'
require 'socialcastr/source'
require 'socialcastr/tag'
require 'socialcastr/tag_list'
require 'socialcastr/recipient'
require 'socialcastr/recipient_list'
require 'socialcastr/thumbnail_list'
require 'socialcastr/media_file'
require 'socialcastr/media_file_list'
require 'socialcastr/external_resource'
require 'socialcastr/external_resource_list'
require 'socialcastr/message'
require 'socialcastr/message_list'

require 'singleton'

module Socialcastr

  class MissingConfiguration < StandardError; end;

  class Configuration
    include Singleton
    ATTRIBUTES = [:domain, :username, :password, :config_file]
    attr_accessor *ATTRIBUTES

    def ready?
      [@domain, @username, @password].each do |attribute|
        return false if attribute.blank?
      end
      return true
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
      end 
    end 
    Configuration.instance
  end 

  def self.api
    config = Configuration.instance
    raise MissingConfiguration unless config.username
    API.new(config.username, config.password, config.domain)
  end
  
end
