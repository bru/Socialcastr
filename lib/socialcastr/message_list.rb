module Socialcastr
  class MessageList < Base
    elements :message, :as => :messages, :class => Message
  end
end
