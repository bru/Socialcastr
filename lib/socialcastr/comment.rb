module Socialcastr
  class Comment < Base
    def like!
      api.post(element_path(:message_id => message_id) + "/likes")
      refresh
      return self
    end

    def unlike!
      api.delete(element_path(:message_id => message_id) + "/likes/#{like_id}")
      refresh
      return self
    end

    def unlikable_by?(api_id)
      self.likes.map{|l| l.unlikable_by?(api_id)}.any?
    end
    
    def likable_by?(api_id)
      self.user.id  != api_id
    end
    
    def like_id
      self.likes.select { |like| like.unlikable_by?(api.profile.id) }.first.id
    end
  end
end
