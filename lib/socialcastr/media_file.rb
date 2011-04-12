module Socialcastr
  class MediaFile < Base
    element :external_resource_id
    element :page_url
    element :attachment_id
    element :content_type
    element :url
    element :thumbnails, :class => Socialcastr::ThumbnailList
    element :title
    element :description
  end
end
