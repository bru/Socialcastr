module Socialcastr
  class CommentList < Collection
    collection_of :comment, :as => :comments, :class => Socialcastr::Comment
  end
end
