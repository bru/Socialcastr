module Socialcastr
  class CommentList < Base
    element :comment, :as => :comments, :class => Socialcastr::Comment
  end
end
