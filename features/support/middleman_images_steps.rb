require 'mini_magick'

Then(/^the dimensions of the file "([^"]*)" should be (\d+)x(\d+)$/) do |path, x, y|
  image = MiniMagick::Image.open expand_path(path)
  expect(image.dimensions).to eql [x.to_i, y.to_i]
end

Then(/^the file "([^"]*)" should be smaller than the file "([^"]*)"/) do |file1, file2|
  expect(File.size(expand_path(file1)) < File.size(expand_path(file2))).to be_truthy
end

