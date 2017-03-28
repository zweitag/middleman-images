require 'mini_magick'

Then(/^the dimensions of the file "([^"]*)" should be (\d+)x(\d+)$/) do |path, x, y|
  image = MiniMagick::Image.open expand_path(path)
  expect(image.dimensions).to eql [x.to_i, y.to_i]
end

