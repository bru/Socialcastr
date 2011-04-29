$:.unshift("./lib")
require 'rubygems'
require 'socialcastr'

Socialcastr.configuration do |config|
  config.username = "username"
  config.password = "password"
  config.domain = "domain"
end

xml = File.read("/Users/bru/Desktop/socialcast.xml")
start_time = Time.new
messages = Socialcastr::Message.parse(xml)
end_time = Time.new

puts "Found #{messages.count} messages in #{end_time - start_time} seconds"
