$:.unshift('./lib')
require 'rubygems'
require 'socialcastr'

Socialcastr.configuration do |c|
  c.config_file = File.join(File.dirname(__FILE__), "socialcast.yml")
end

message = Socialcastr::Message.new( :title => "hello world", :body => "yet another message")

puts "message created: #{message.to_params.inspect}"

message.save
