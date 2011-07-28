module Socialcastr
  class Like < Base
    def unlikable_by?(api_id)
      api_id == self.user.id ? true : false
    end
  end
end
