require "middleman-core"

Middleman::Extensions.register :images do
  require "middleman-images/extension"
  require "middleman-images/image"
  require "middleman-images/manipulator"
  Middleman::Images::Extension
end
