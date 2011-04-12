module Socialcastr
  class Message < Base

    element :title
    element :body
    element :url
    element :permalink_url
    element :action
    element :external_url
    element :icon
    element :id
    element :likable
    element :created_at
    element :updated_at
    element :last_interacted_at
    element :player_url
    element :thumbnail_url
    element :player_params
    element :user, :class => Socialcastr::User
    element :group, :class => Socialcastr::Group
    element :groups, :as => :group_list, :class => Socialcastr::GroupList
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
    element :recipients, :as => :recipient_list, :class => Socialcastr::RecipientList

    element :attachments, :as => :attachment_list, :class => Socialcastr::AttachmentList
    element :tags, :as => :tag_list, :class => Socialcastr::TagList
    element :likes, :as => :like_list, :class => Socialcastr::LikeList
    element :external_resources, :as => :external_resource_list, :class => Socialcastr::ExternalResourceList
    element :media_files, :as => :media_file_list, :class => Socialcastr::MediaFileList
    element :likes_count
    element :hidden

    element :comments, :as => :comment_list, :class => Socialcastr::CommentList

  end
end
