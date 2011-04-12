module Socialcastr
  class RecipientList < Base
    elements :recipient, :as => :recipients, :class => Socialcastr::Recipient
  end
end

