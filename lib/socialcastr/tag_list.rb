module Socialcastr
  class TagList < Base
    elements :tag, :as => :tags, :class => Socialcastr::Tag
  end
end
