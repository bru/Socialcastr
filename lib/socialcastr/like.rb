module Socialcastr
  class Like < Base
    def unlikable_by?(api_id)
      @unlikable && api_id == self.user_id ? true : false
    end
  end
end
