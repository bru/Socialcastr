module Socialcastr
  class MessageList < Collection
    collection_of :message, :as => :messages, :class => Message
  end
end
