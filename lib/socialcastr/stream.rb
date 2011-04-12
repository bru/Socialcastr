module Socialcastr
  class Stream < Base
    element :id
    element :name
    element :default
    element :last_interacted_at
    element :custom_stream
    element :group, :class => Socialcastr::Group
  end
end
