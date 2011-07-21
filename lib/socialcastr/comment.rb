module Socialcastr
  class Comment < Base
    def like!
      self.likes ||= []
      likes << Like.parse(api.post(element_path(:message_id => self.message_id) + "/likes"))
    end

    def unlike!
      self.likes.reject! do |l|
        l.unlikable_by?(self.user_id) && api.delete(element_path(:message_id => self.mesage_id) + "/likes/#{l.id}")
      end
    end

    def unlikable_by?(api_id)
      self.likes.map{|l| l.unlikable_by?(api_id)}.any?
    end
    
    def likable_by?(api_id)
      self.user_id  != api_id
    end
    
    def like_id(api_id)
      self.likes.select { |like| like.unlikable_by?(api_id) }.first.id
    end
  end
end
