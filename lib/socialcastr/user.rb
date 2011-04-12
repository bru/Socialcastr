module Socialcastr
  class User < Base
    element :type
    element :terminated
    element :username
    element :avatars, :class => AvatarList
    element :url
    element :name
    element :id
  end
end
