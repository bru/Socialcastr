module Socialcastr
  class UserList < Collection
    collection_of :user, :as => :users, :class => User
  end
end
