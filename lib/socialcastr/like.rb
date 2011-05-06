module Socialcastr
  class Like < Base
    id_element
    element :unlikable
    element :user, :class => Socialcastr::User
    element :created_at
    def unlikable_by?(api_id)
      @unlikable && api_id == self.user_id ? true : false
    end
  end
end
