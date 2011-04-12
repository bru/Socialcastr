module Socialcastr
  class GroupList < Base
    elements :group, :as => :groups, :class => Socialcastr::Group
  end
end
