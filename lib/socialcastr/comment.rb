module Socialcastr
  class Comment < Base
    element :editable
    element :attachments, :as => :attachment_list, :class => Socialcastr::AttachmentList
    element :likable
    element :deletable
    element :likes, :as => :like_list, :class => Socialcastr::LikeList
    element :permalink_url
    element :text
    element :user, :class => Socialcastr::User
    element :thumbnail_url
    element :url
    element :likes_count
    element :created_at
    element :id

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
