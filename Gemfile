# If you do not have OpenSSL installed, update
# the following line to use "http://" instead
source 'https://rubygems.org'

# Specify your gem's dependencies in middleman-images.gemspec
gemspec

group :development do
  gem 'image_optim', '>= 0.24.2'
  gem 'middleman'
  gem 'rake'
  gem 'rdoc'
  gem 'yard'
end

group :test do
  gem 'cucumber'
  gem 'capybara'
  gem 'aruba'
  gem 'rspec'

  # Version is locked to make sure asset_hash tests are not broken by updated optimizations.
  gem 'image_optim_pack', '=0.6.0'
end
