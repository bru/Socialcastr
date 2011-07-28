module Socialcastr

  class Message < Base

    def flag!
      return true if flagged?
      Socialcastr::Flag.new({}, :message_id => id).save
      refresh
    end

    def flagged?
      self.flag && !self.flag.id.nil?
    end

    def unflag!
      return unless flagged?
      self.flag.destroy
      refresh  
    end

    def like!
      Socialcastr::Like.new({}, :message_id => id).save
      refresh
    end

    def likable_by?(api_id)
      return false if self.user.id == api_id
      like_for(api_id).nil?
    end

    def like_for(api_id)
      return nil if (self.likes.nil? || self.likes.empty?)
      self.likes.select { |like| like.unlikable_by?(api_id) }.first
    end

    def unlike!
      self.likes.reject! do |l|
        l.unlikable && l.destroy
      end
    end

    def comment!(arguments={})
      Socialcastr::Comment.new(arguments, :message_id => id).save
      refresh
    end
    

    def self.search(query, arguments={})
      xml = api.get(collection_path + "/search", { :q => query}.merge(arguments))
      return parse(xml)
    end
  end
end
