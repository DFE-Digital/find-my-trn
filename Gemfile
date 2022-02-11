# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.3'

gem 'bootsnap', require: false
gem 'govuk-components'
gem 'govuk_design_system_formbuilder'
gem 'govuk_markdown', '~> 1.0'
gem 'importmap-rails'
gem 'logstop', '~> 0.2.8'
gem 'pg', '~> 1.3'
gem 'puma', '~> 5.6'
gem 'rails', '~> 7.0.1'
gem 'sprockets-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'foreman', '~> 0.87.2'
  gem 'prettier', '~> 2.0'
  gem 'rladr', '~> 1.2'
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem 'capybara', '~> 3.36'
  gem 'cuprite', '~> 0.13'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 5.1'
end
