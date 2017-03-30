activate :images do |config|
  config.optimize = true
  config.image_optim_options = {
    pngout: false,
    svgo: false
  }
end
