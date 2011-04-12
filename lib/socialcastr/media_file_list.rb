module Socialcastr
  class MediaFileList < Base
    elements :media_file, :as => :media_files, :class => Socialcastr::MediaFile
  end
end
