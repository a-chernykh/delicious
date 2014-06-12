module Delicious
  autoload :Client, 'delicious/client'
  autoload :Post,   'delicious/post'

  module Methods
    autoload :All,    'delicious/methods/all'
    autoload :Post,   'delicious/methods/post'
    autoload :Delete, 'delicious/methods/delete'
  end
end
