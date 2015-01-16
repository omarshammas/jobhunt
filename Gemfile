source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '~> 3.3.1'
gem 'autoprefixer-rails', '~> 4.0.2.2'
# Use Haml for views
gem 'haml', '~> 4.0.5'
gem 'haml-rails', '~> 0.6.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'figaro', '~> 1.0.0'

gem 'sidekiq', '~> 3.3.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#gem 'crunchbase_v2', '0.0.8'
gem 'crunchbase_v2', git: 'https://github.com/omarshammas/crunchbase_v2.git'
gem 'angellist_api', '1.0.7'
gem 'redis', '~> 3.2.0'

# sidekiq monitoring
# if you require 'sinatra' you get the DSL extended to Object
gem 'sinatra', require: nil

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails', '~> 4.5.0'
end

group :test do
  gem 'database_cleaner', '~> 1.4.0'
  gem 'shoulda-matchers', '~> 2.7.0', require: false
  gem 'capybara', '~> 2.4.4'
  gem 'selenium-webdriver', '~> 2.44.0' # useful for debugging, but phantomjs is the default
  gem 'poltergeist', '~> 1.5.1'
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.20.4'
  gem 'fakeredis', '~> 0.5.0'
  gem 'rspec-sidekiq', '~> 2.0.0'
end

# deployment on heroku
gem 'rails_12factor', group: :production
ruby '2.2.0'
