module Socialcastr
  class Group < Base
    element :url
    element :id
    element :name
    element :avatars, :class => Socialcastr::AvatarList
    
  end
end
