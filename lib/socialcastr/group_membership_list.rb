module Socialcastr
  class GroupMembershipList < Base
    elements :group_membership, :as => :group_memberships, :class => Socialcastr::GroupMembership
  end
end
