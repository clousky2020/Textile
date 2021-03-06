source 'https://gems.ruby-china.com'
git_source(:github) {|repo| "https://github.com/#{repo}.git"}

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 5.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem "ransack"
# 操作Excel
gem 'creek'
# 分页
gem 'kaminari'
# 权限管理
gem 'cancancan'
gem 'role_core'
# 上传图片
gem 'carrierwave'
gem 'mini_magick'
# i18n
gem 'rails-i18n', '~> 6.0.0'
gem 'carrierwave-i18n'

# 图标
gem 'font-awesome-sass', '~> 5.15.1'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
# 自动部署
gem 'mina'
# gem 'mina-puma', require: false
gem 'mina-systemd', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'launchy'
end

group :test do
  gem 'capybara'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'factory_bot_rails'
  gem 'cuprite'
  gem 'database_cleaner'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'heavens_door'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-bundler', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
