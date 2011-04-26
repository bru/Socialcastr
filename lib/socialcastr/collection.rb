module Socialcastr
  class Collection < Base
    include Enumerable

    attr_accessor :method

    def initialize
      @members_method = self.class.members_method
    end

    def each &block
      members.each{|member| block.call(member)}
    end

    def size
      members.size
    end

    def members
      send @members_method
    end

    def self.collection_of(name, options={})
      if options[:as]
        @members_method = options[:as]
      else
        @members_method = name
      end
      elements name, options
    end

    def self.members_method
      @members_method
    end
  end
end
