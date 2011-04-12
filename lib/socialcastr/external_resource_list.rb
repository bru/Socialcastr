module Socialcastr
  class ExternalResourceList < Base
    elements :external_resource, :as => :external_resources, :class => ExternalResource
  end
end
