require 'net/http'
require 'net/https'
require 'openssl'
require 'uri'
require 'digest/md5'
require 'cgi'

module Socialcastr
  class API
    attr_accessor :debug
    
    def initialize(username, password, domain, format="xml",debug=false)
      @debug    = debug
      @username = username
      @password = password
      @format   = format
      @domain   = domain
      @endpoint = "https://#{domain}/api/"
      return self
    end

    def profile
      @profile ||= Socialcastr::Community.parse(post("authentication", {:email => @username, :password => @password })).
                      select { |community| community.domain == @domain }.
                      first.profile
    end

    def get(path, args={})
      https_request(:get, path, args)
    end   
    
    def put(path, args={})
      https_request(:put, path, args)
    end

    def post(path, args={})
      https_request(:post, path, args)
    end
    
    def delete(path, args={})
      https_request(:delete, path, args)
    end

    def https_request(method, path, args)
      https = setup_https

      case method
        when :get
          request_class = Net::HTTP::Get
          query=args
        when :post
          request_class = Net::HTTP::Post
          form_data = args
        when :put
          request_class = Net::HTTP::Put
          form_data = args
        when :delete
          request_class = Net::HTTP::Delete
        else
          raise InvalidMethod
      end
      response = nil
      https.start do |session|
        query_string = build_query_string(path, query)
        req = request_class.new(query_string)
        req.basic_auth @username, @password
        if form_data
          req.set_form_data(args, ';')
        end
        response = session.request(req)
      end

      return handle_response(response).body
    end
    

    # Handles response and error codes from the remote service.
    def handle_response(response)
      case response.code.to_i
        when 301,302
          raise(Redirection.new(response))
        when 200...400
          response
        when 400
          raise(BadRequest.new(response))
        when 401
          raise(UnauthorizedAccess.new(response))
        when 403
          raise(ForbiddenAccess.new(response))
        when 404
          raise(ResourceNotFound.new(response))
        when 405
          raise(MethodNotAllowed.new(response))
        when 409
          raise(ResourceConflict.new(response))
        when 410
          raise(ResourceGone.new(response))
        when 422
          raise(ResourceInvalid.new(response))
        when 401...500
          raise(ClientError.new(response))
        when 500...600
          raise(ServerError.new(response))
        else
          raise(ConnectionError.new(response, "Unknown response code: #{response.code}"))
      end
    end
    
    def setup_https
      url   = URI.parse(@endpoint) 
      https = Net::HTTP.new(url.host, url.port)
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      if @debug
        https.set_debug_output $stderr
      end
      https.use_ssl = true
      return https
    end

    def build_query_string(path, query=nil)
      params = []
      unless query.nil?
        params = query.collect do |k,v| 
          "#{k.to_s}=#{CGI::escape(v.to_s)}" 
        end
      end
      "/api#{path.to_s =~ /^\// ? path.to_s : "/" + path.to_s }.#{@format}" + (params.any? ? "?" + params.join('&') : "")
    end
  end
end
