module Socialcastr
  class Comment < Base
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
