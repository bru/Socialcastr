module Socialcastr
  class Like < Base
    element :unlikable
    element :user, :class => Socialcastr::User
    element :created_at
    element :id
    def unlikable_by?(api_id)
      @unlikable && api_id == self.user_id ? true : false
    end
  end
end
