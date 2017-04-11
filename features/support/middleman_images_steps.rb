require 'mini_magick'

Then(/^the dimensions of the file "([^"]*)" should be (\d+)x(\d+)$/) do |path, x, y|
  image = MiniMagick::Image.open expand_path(path)
  expect(image.dimensions).to eql [x.to_i, y.to_i]
end

Then(/^the file "([^"]*)" should be smaller than the file "([^"]*)"/) do |file1, file2|
  expect(File.size(expand_path(file1)) < File.size(expand_path(file2))).to be_truthy
end

Then /^the content length should be equal to the file size of "([^\"]*)"$/ do |file|
  expect(page.response_headers['Content-Length'].to_i).to eq File.size(expand_path(file))
end

Then /^the content length should be smaller than the file size of "([^\"]*)"$/ do |file|
  expect(page.response_headers['Content-Length'].to_i).to be < File.size(expand_path(file))
end
