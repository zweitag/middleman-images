activate :images do |config|
  config.optimize = false
  config.image_optim = {
    pngout: false,
    svgo: false
  }
end
