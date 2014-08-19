source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.5'
gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '~> 2.5.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.1.0'
gem 'will_paginate', '~> 3.0'
gem 'redis'
gem 'puma'
gem 'brakeman', require: false
gem 'figaro'
gem 'sidekiq'
gem 'tubesock', git: 'git://github.com/ngauthier/tubesock.git', branch: 'master'
gem 'mail_form'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'humane-rails'
gem 'foreman'
gem 'newrelic_rpm'
gem 'rack-rewrite'
gem 'curb'

group :doc do
  gem 'sdoc', require: false
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'capybara'
  gem 'webmock'
  gem 'vcr'
  #gem 'fakeredis'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter'
  gem 'coveralls', require: false
  gem 'capybara-webkit'
end
