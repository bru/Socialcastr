module Socialcastr
  class GroupMembership < Base
    element :group, :class => Socialcastr::Group
    element :role
  end
end
