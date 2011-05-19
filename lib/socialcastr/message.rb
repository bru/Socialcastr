module Socialcastr
  class Message < Base

    def flag!
      return true if flagged?
      flag.copy_attributes_from_object(Flag.parse(api.post(element_path + "/flags")))
    end

    def flagged?
      !flag.id.nil?
    end

    def unflag!
      return unless flagged?
      api.delete(element_path + "/flags/#{flag.id}")
      @flag = Flag.new
    end

    def like!
      likes << Like.parse(api.post(element_path + "/likes"))
    end

    def unlike!
      likes.reject! do |l|
        l.unlikable && api.delete(element_path + "/likes/#{l.id}")
      end
    end

    def comment!(arguments={})
      comment = Socialcastr::Comment.new(arguments)
      api.post(element_path + "/comments", comment.to_params)
    end
    

    def self.search(arguments={})
      parse_collection(api.get(collection_path + "/search", arguments))
    end
  end
end
