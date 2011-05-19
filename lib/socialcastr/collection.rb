module Socialcastr
  class Collection < Base
    include Enumerable

    def each &block
      @doc.each{|member| block.call(member)}
    end

    def size
      @doc.size
    end
  end
end
