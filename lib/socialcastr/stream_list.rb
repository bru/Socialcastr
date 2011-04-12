module Socialcastr
  class StreamList < Base
    elements :stream, :as => :streams, :class => Socialcastr::Stream
  end
end
