module Socialcastr
  class AttachmentList < Base
    elements :attachment, :as => :attachments, :class => Attachment
  end
end
