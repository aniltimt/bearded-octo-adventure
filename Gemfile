source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
  gem 'execjs', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery_datepicker'
gem 'savon'

group :development, :test do
  gem 'mail'
  gem 'rspec-rails', '~> 2.13.0'
  gem 'shoulda', :require => false
  gem 'capybara', :require => false
  gem 'launchy', :require => false
  gem 'database_cleaner', :require => false                # for use with capybara tests
  gem 'factory_girl', '~> 4.1'          # for generating test models
  gem 'factory_girl_rails', require:false
  gem 'forgery'                         # for generating test data
  gem 'simplecov', :require => false    # Test coverage
  gem "selenium-webdriver", "~> 2.31.0" # for AJAX testing
  gem "debugger"
  gem "rspec-fire"
  gem "timecop"
end

group :test do
  gem 'spork-rails' # pre-load rails environment for faster test launches
  gem "webmock"
end

gem 'american_date'             # by default, dates are parsed/formatted with American style
gem 'authlogic', '~> 3.2'       # user login
gem 'attr_encrypted', '~> 1.2'  # encrypt activerecord attributes in db
gem 'capistrano'                # deployment of application
gem 'capistrano-ext'
gem 'daemons'                   # used for running delayed_job jobs
gem 'delayed_job'               # handle a task in a process outside of the Rails app
gem 'delayed_job_active_record' # support delayed_job
gem 'encryptor', '~> 1.1'
gem 'liquid', '~> 2.5.0'        # rendering templates, such as Marketing::Email::Template
gem 'paperclip'                 # handle file attachments to activerecord
gem 'nested_form'
gem 'rails3-jquery-autocomplete'
gem 'remotipart', '~> 1.0'
gem 'tinymce-rails'
gem 'whenever', :require => false # handles scheduled tasks
gem 'will_paginate', '~> 3.0'   # paginates index pages for activerecord
