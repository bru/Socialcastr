module Socialcastr
  class Recipient < Base
    element :type
    element :username
    element :avatars, :class => Socialcastr::AvatarList
    element :url 
    element :name
    element :id
    element :private
  end
end
