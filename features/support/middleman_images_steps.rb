require "mini_magick"

Given /^a middleman configuration with:$/ do |config|
  @middleman_config = config
end

Given /^our extension is enabled?$/ do
  step "our extension is enabled with:", ""
end

Given /^our extension is enabled with:$/ do |config|
  config = "" "
    #{@middleman_config}

    activate :images do |config|
      config.image_optim = {
        pngout: false,
        svgo: false,
      }
      #{config}
    end
  " ""
  step 'a file named "config.rb" with:', config
end

Then /^the dimensions should be (\d+)x(\d+)$/ do |x, y|
  image = MiniMagick::Image.read page.body
  expect(image.dimensions).to eql [x.to_i, y.to_i]
end

Then /^the content length should be equal to the file size of "([^\"]*)"$/ do |file|
  expect(page.response_headers["Content-Length"].to_i).to eq File.size(expand_path(file))
end

Then /^the content length should be smaller than the file size of "([^\"]*)"$/ do |file|
  expect(page.response_headers["Content-Length"].to_i).to be < File.size(expand_path(file))
end
