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
      @endpoint = "https://#{domain}/api/"
      return self
    end
    
    def messages(stream=nil, query={})
      method="messages"
      method.insert(0, "streams/#{stream.id}/") if stream
      xml = api_get(method, query)
      return Socialcastr::MessageList.parse(xml).messages
    end
    
    def search(query)
      method="messages/search"
      xml = api_get(method, query)
      return Socialcastr::MessageList.parse(xml).messages
    end
    
    def groups
      method = "group_memberships"
      xml = api_get(method)
      return Socialcastr::GroupMembershipList.parse(xml).group_memberships
    end
    
    def streams
      method = "streams"
      xml = api_get(method)
      return Socialcastr::StreamList.parse(xml).streams
    end
    
    def add_message(message)
      xml = api_post("messages", message)
      return xml
    end
    
    def add_comment(message_id, comment)
      xml = api_post("messages/#{message_id}/comments", comment)
      return xml
    end
    
    def like_comment(message_id,comment_id)
      xml = api_post("messages/#{message_id.to_s}/comments/#{comment_id.to_s}/likes")
      return xml
    end
    
    def unlike_comment(message_id,comment_id,like_id)
      xml = api_delete("messages/#{message_id}/comments/#{comment_id}/likes/#{like_id}")
      return xml
    end
    
    def https_request(method, path, args)
      https = setup_https
      response = ""
      
      # HACK
      # if path == "messages/search"
      #   path = "messages"
      # end
      # data = File.read(File.join('/tmp','fixtures','xml', "#{path}.#{@format}"))
      # return data
      # # /HACK

      case method
        when 'get'
        request_class = Net::HTTP::Get
        query=args
        when 'post'
        request_class = Net::HTTP::Post
        form_data = args
        when 'put'
        request_class = Net::HTTP::Put
        form_data = args
        when 'delete'
        request_class = Net::HTTP::Delete
      end
      https.start do |session|
        query_string = "/api/#{path}.#{@format}"
        query_string += "?" + (query.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')) unless query.nil?
        req = request_class.new(query_string)
        req.basic_auth @username, @password
        if form_data
          req.set_form_data(args, ';')
        end
        response = session.request(req).body
      end

      response  
    end
    
    def api_get(path, args={})
      https_request('get', path, args)
    end   
    
    
    def api_post(path, args={})
      https_request('post', path, args)
    end
    
    def api_delete(path, args={})
      https_request('delete', path, args)
    end
    
    def setup_https
      url   = URI.parse(@endpoint) 
      https = Net::HTTP.new(url.host, url.port)
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
      https.use_ssl = true
      return https
    end
  end
end
