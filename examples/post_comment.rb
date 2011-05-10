$:.unshift('./lib')
require 'rubygems'
require 'socialcastr'

Socialcastr.configuration do |c|
  c.config_file = File.join(File.dirname(__FILE__), "socialcast.yml")
end

message = Socialcastr::Message.last

message.comment! :text => "hallo from Socialcastr"
