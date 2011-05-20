module Socialcastr

  class Message < Base

    def flag!
      return true if flagged?
      self.flag = Socialcastr::Flag.parse(api.post(element_path + "/flags"))
    end

    def flagged?
      self.flag && !self.flag.id.nil?
    end

    def unflag!
      return unless flagged?
      api.delete(element_path + "/flags/#{self.flag.id}")
      self.flag = nil
    end

    def like!
      self.likes ||= []
      likes << Like.parse(api.post(element_path + "/likes"))
    end

    def unlike!
      self.likes.reject! do |l|
        l.unlikable && api.delete(element_path + "/likes/#{l.id}")
      end
    end

    def comment!(arguments={})
      comment = Socialcastr::Comment.new(arguments)
      api.post(element_path + "/comments", comment.to_params)
    end
    

    def self.search(query, arguments={})
      puts "searching for #{query}"
      xml = api.get(collection_path + "/search", { :q => query}.merge(arguments))
      puts "Got a response xml of #{xml.length} bytes"
      return parse(xml)
    end
  end
end
