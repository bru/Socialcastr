module Socialcastr
  class Message < Base

    id_element :id
    element :title
    element :body
    element :url
    element "permalink-url", :as => :permalink_url
    element :action
    element "external-url", :as => :external_url
    element :icon
    element :likable
    element "created-at", :as => :created_at
    element "updated-at", :as => :updated_at
    element "last-interacted-at", :as => :last_interacted_at
    element "player-url", :as => :player_url
    element "thumbnail-url", :as => :thumbnail_url
    element "player-params", :as => :player_params
    element :user, :class => Socialcastr::User
    #element :group, :class => Socialcastr::Group
    elements :group, :as => :groups, :class => Socialcastr::Group
    element :source, :class => Socialcastr::Source

    element :editable
    element :rating
    element "category-id", :as => :category_id
    element :subscribed
    # element :ratings_average
    element :flag, :class => Socialcastr::Flag
    element :deletable
    element "comments-count", :as => :comments_count
    element :verb
    element "in-reply-to", :as => :in_reply_to
    element :watchable
    element "contains-url-only", :as => :contains_url_only
    # element :target_user
    element :ratable
    element "message-type", :as => :message_type
    elements :recipient, :as => :recipients, :class => Socialcastr::Recipient

    elements :attachment, :as => :attachments, :class => Socialcastr::Attachment
    elements :tag, :as => :tags, :class => Socialcastr::Tag
    elements :like, :as => :likes, :class => Socialcastr::Like
    elements "external-resource", :as => :external_resources, :class => Socialcastr::ExternalResource
    elements "media-file", :as => :media_files, :class => Socialcastr::MediaFile
    element "likes-count", :as => :likes_count
    element :hidden

    elements :comment, :as => :comments, :class => Socialcastr::Comment

    def flag!
      return true if flagged?
      flag.copy_attributes_from_object(Flag.parse(api.post(element_path + "/flags")))
    end

    def flagged?
      !flag.id.nil?
    end

    def unflag!
      return unless flagged?
      api.delete(element_path + "/flags/#{flag.id}")
      @flag = Flag.new
    end

    def like!
      likes << Like.parse(api.post(element_path + "/likes"))
    end

    def unlike!
      likes.reject! do |l|
        l.unlikable && api.delete(element_path + "/likes/#{l.id}")
      end
    end

    def comment!(arguments={})
      comment = Socialcastr::Comment.new(arguments)
      api.post(element_path + "/comments", comment.to_params)
    end
    

    def self.search(arguments={})
      parse_collection(api.get(collection_path + "/search", arguments))
    end
  end
end
