require "middleman-core"

Middleman::Extensions.register :images do
  require "middleman-images/extension"
  require "middleman-images/image"
  Middleman::Images::Extension
end
