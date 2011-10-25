require "rubygems"
require "bundler"
Bundler.setup

require 'rspec'
require 'artifice'

$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'socialcastr'

RSpec.configure do |config|
  config.before :each do 
    Socialcastr.configuration.reset
  end
end
def generate_fake_endpoint(response, code=200)
  return proc { |env|
    [code, {"Content-Type"  => "text/html",
           "X-Test-Method" => env["REQUEST_METHOD"],
           "X-Test-Input"  => env["rack.input"].read,
           "X-Test-Scheme" => env["rack.url_scheme"],
           "X-Test-Host"   => env["HTTP_HOST"] || env["SERVER_NAME"],
           "X-Test-Port"   => env["SERVER_PORT"]},
      [response]
    ]
  }
end

def configure_socialcastr
    Socialcastr.configuration do |c|
      c.username = "demo"
      c.password = "password"
      c.domain   = "demo.socialcast.com"
    end
end

def fake_socialcast_api_for(type, &block)
  configure_socialcastr
  case type
  when :message
    responsefile = "message.xml"
  when :messages
    responsefile = "messages.xml"
  when :user
    responsefile = "user.xml"
  end
  response = File.read(File.join(File.dirname(__FILE__), 'fixtures', responsefile))
  endpoint = generate_fake_endpoint(response)
  if block
    Artifice.activate_with(generate_fake_endpoint(response)) do
      block.call
    end
  else
    Artifice.activate_with(generate_fake_endpoint(response))
  end
end
