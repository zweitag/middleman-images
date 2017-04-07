require 'mini_magick'

Then(/^the dimensions of the file "([^"]*)" should be (\d+)x(\d+)$/) do |path, x, y|
  image = MiniMagick::Image.open expand_path(path)
  expect(image.dimensions).to eql [x.to_i, y.to_i]
end

Then(/^the exif data of the file "([^"]*)" should( not)? be empty$/) do |path, negated|
  image = MiniMagick::Image.open expand_path(path)
  if negated
    expect(image.exif).to_not be_empty
  else
    expect(image.exif).to be_empty
  end
end

Then(/^the file "([^"]*)" should be smaller than the file "([^"]*)"/) do |file1, file2|
  expect(File.size(expand_path(file1)) < File.size(expand_path(file2))).to be_truthy
end

