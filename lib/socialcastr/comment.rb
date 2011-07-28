module Socialcastr
  class Comment < Base
    def like!
      Socialcastr::Like.new({}, to_prefix_options).save
      refresh
      return self
    end

    def unlike!
      like.destroy
      refresh
      return self
    end

    def unlikable_by?(api_id)
      self.likes.map{|l| l.unlikable_by?(api_id)}.any?
    end
    
    def likable_by?(api_id)
      return false if self.user.id == api_id
      like_for(api_id).nil?
    end
    
    def like_for(api_id)
      self.likes.select { |like| like.unlikable_by?(api_id) }.first
    end
  end
end
