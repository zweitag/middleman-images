activate :images do |config|
  config.optimize = true
  config.image_optim = {
    pngout: false,
    svgo: false
  }
end
