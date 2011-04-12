module Socialcastr
  class LikeList < Base
    element :like, :as => :likes, :class => Socialcastr::Like
  end
end
