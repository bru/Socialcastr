module Socialcastr
  class GroupMembershipList < Collection
    collection_of :group_membership, :as => :group_memberships, :class => Socialcastr::GroupMembership
  end
end
