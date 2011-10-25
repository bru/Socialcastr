module Socialcastr
  class User < Base
    def self.search(query)
      Socialcastr::Base.parse(api.get("users/search", :q => query))
    end
  end
end
