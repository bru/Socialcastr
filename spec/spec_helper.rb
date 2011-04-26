require "rubygems"
require "bundler"
Bundler.setup

require 'rspec'
require 'artifice'

$: << File.join(File.dirname(__FILE__), '..', 'lib')
require 'socialcastr'

def generate_fake_endpoint(response)
  return proc { |env|
    [200, {"Content-Type"  => "text/html",
           "X-Test-Method" => env["REQUEST_METHOD"],
           "X-Test-Input"  => env["rack.input"].read,
           "X-Test-Scheme" => env["rack.url_scheme"],
           "X-Test-Host"   => env["HTTP_HOST"] || env["SERVER_NAME"],
           "X-Test-Port"   => env["SERVER_PORT"]},
      [response]
    ]
  }
end

def fake_socialcast_api_for(type, &block)
  case type
  when :messages
    responsefile = "messages.xml"
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
