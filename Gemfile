source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'


gem 'rails', '~> 6.0.0'
gem 'bcrypt', '~> 3.1.7'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5'
gem 'webpacker', '~> 4.0'
gem 'ruby-debug-ide'
gem 'debase'
gem 'jbuilder', '~> 2.7'
gem 'fog-aws'
gem 'devise'
gem 'jquery-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'

#必要なgemを最初に入れておきます。
gem 'jquery-rails'
gem 'carrierwave'
gem "rmagick"
gem 'will_paginate'
gem 'bootstrap-will_paginate'
#ダミーデータを作るためのもの
gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
#font-awesomeを使う
gem 'font-awesome-rails'

gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem 'rspec-rails'
  gem 'capybara', '>= 2.15'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem "simplecov"
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'letter_opener_web'
  gem 'letter_opener'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring-commands-rspec'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'pg', '0.20.0'
end

group :test do
  gem 'database_rewinder'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'launchy'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
