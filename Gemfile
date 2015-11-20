source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use mysql2 as the database for Active Record
gem 'mysql2', '~> 0.3.19'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'haml-rails'

# Use Rspec rather than test_unit
gem 'rspec-rails'

# OAuth2 login
gem 'dotenv-rails'
gem 'figaro'
gem 'omniauth-google-oauth2'
gem 'activerecord-session_store'

# Websockets magic
gem 'websocket-rails'

# Fix a bug within a websocket-rails dependency
# https://github.com/websocket-rails/websocket-rails/issues/379
gem 'faye-websocket', '0.10.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false

  # Allow Grunt to be run from capistrano
  gem 'capistrano-npm'
  gem 'capistrano-grunt'
end

gem 'puma'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Allow time travel
  gem 'timecop'

  # Features and webtesting
  gem 'cucumber'
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :test do
  gem "codeclimate-test-reporter", require: nil
end

# Livereload
group :development do
  gem "guard", ">= 2.2.2",       :require => false
  gem "guard-livereload",        :require => false
  gem "rack-livereload"
  gem "rb-fsevent",              :require => false
end
