# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'bootsnap', require: false
gem 'dry-validation'
gem 'jsonapi.rb'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4', '>= 7.0.4.2'
gem 'sqlite3', '~> 1.4'
gem 'tzinfo-data'
# gem "rack-cors"

group :development, :test do
  gem 'debug'
  gem 'factory_bot_rails'
  gem 'rspec_jsonapi_serializer'
  gem 'rspec-rails'
end

group :development do
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'spring'
end
