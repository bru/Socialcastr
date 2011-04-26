module Socialcastr
  class LikeList < Collection
    collection_of :like, :as => :likes, :class => Socialcastr::Like
  end
end
