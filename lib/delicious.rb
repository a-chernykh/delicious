module Delicious
  autoload :Client,   'delicious/client'
  autoload :ApiModel, 'delicious/api_model'
  autoload :Post,     'delicious/post'
  autoload :Bundle,   'delicious/bundle'
  autoload :Tag,      'delicious/tag'
  autoload :Error,    'delicious/error'

  module Bookmarks
    autoload :Api, 'delicious/bookmarks/api'

    module Methods
      autoload :All,    'delicious/bookmarks/methods/all'
      autoload :Create, 'delicious/bookmarks/methods/create'
      autoload :Delete, 'delicious/bookmarks/methods/delete'
    end
  end

  module Bundles
    autoload :Api, 'delicious/bundles/api'

    module Methods
      autoload :Find,   'delicious/bundles/methods/find'
      autoload :All,    'delicious/bundles/methods/all'
      autoload :Delete, 'delicious/bundles/methods/delete'
      autoload :Set,    'delicious/bundles/methods/set'
    end
  end

  module Tags
    autoload :Api, 'delicious/tags/api'

    module Methods
      autoload :All,    'delicious/tags/methods/all'
      autoload :Delete, 'delicious/tags/methods/delete'
      autoload :Rename, 'delicious/tags/methods/rename'
    end
  end
end
