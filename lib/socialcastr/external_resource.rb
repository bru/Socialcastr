module Socialcastr
  class ExternalResource < Base
    element :type
    element :tags, :as => :tag_list, :class => Socialcastr::TagList
    element :canonical_hashtag
    element :source, :class => Socialcastr::Source
    element :media_files, :as => :media_file_list, :class => Socialcastr::MediaFileList 
    element :url
    element :title
    element :description
    element :id
    
  end
end
