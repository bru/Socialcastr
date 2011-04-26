module Socialcastr
  class ExternalResource < Base
    element :type
    elements :tag, :as => :tags, :class => Socialcastr::Tag
    element :canonical_hashtag
    element :source, :class => Socialcastr::Source
    elements :media_file, :as => :media_files, :class => Socialcastr::MediaFile
    element :url
    element :title
    element :description
    element :id
    
  end
end
