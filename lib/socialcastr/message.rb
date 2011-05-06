module Socialcastr
  class Message < Base

    id_element :id
    element :title
    element :body
    element :url
    element :permalink_url
    element :action
    element :external_url
    element :icon
    element :likable
    element :created_at
    element :updated_at
    element :last_interacted_at
    element :player_url
    element :thumbnail_url
    element :player_params
    element :user, :class => Socialcastr::User
    #element :group, :class => Socialcastr::Group
    elements :group, :as => :groups, :class => Socialcastr::Group
    element :source, :class => Socialcastr::Source

    element :editable
    element :rating
    element :category_id
    element :subscribed
    # element :ratings_average
    element :flag, :class => Socialcastr::Flag
    element :deletable
    element :comments_count
    element :verb
    element :in_reply_to
    element :watchable
    element :contains_url_only
    # element :target_user
    element :ratable
    element :message_type
    elements :recipient, :as => :recipients, :class => Socialcastr::Recipient

    elements :attachment, :as => :attachments, :class => Socialcastr::Attachment
    elements :tag, :as => :tags, :class => Socialcastr::Tag
    elements :like, :as => :likes, :class => Socialcastr::Like
    elements :external_resource, :as => :external_resources, :class => Socialcastr::ExternalResource
    elements :media_files, :as => :media_file, :class => Socialcastr::MediaFile
    element :likes_count
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

    def self.search(arguments={})
      parse_collection(api.get(collection_path + "/search", arguments))
    end
  end
end
