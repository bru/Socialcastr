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
    element :flag
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

  end
end
