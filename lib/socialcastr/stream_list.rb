module Socialcastr
  class StreamList < Collection
    collection_of :stream, :as => :streams, :class => Socialcastr::Stream
  end
end
