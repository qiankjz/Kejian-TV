#source 'http://ruby.taobao.org/'
source 'https://rubygems.org'

ruby "2.0.0"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
gem 'rails', '>=3.2.10'
gem 'rake', '>=10', :require => 'rake/testtask'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# MongoDB
gem "mongoid", "~> 3"
# gem 'mongoid_auto_increment_id', "0.5.0"
# gem 'mongoid_rails_migrations', '~> 0.0.14'
gem "mongoid_colored_logger", :github => "huacnlee/mongoid_colored_logger", :group => :development
gem "bson_ext"
gem 'mysql2'
#gem 'pry-rails'
gem 'pry'

# gem 'jstree-rails', :git => 'git://github.com/tristanm/jstree-rails.git'

# Gems used only for assets and not required
# in production environments by default.

#group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
#end
gem 'jquery-rails', '~> 2.1.4', github: 'rails/jquery-rails'
gem 'turbolinks'
gem "jquery-atwho-rails", ">=0.1.6" #[!]
# 禁用 assets 日志
gem 'quiet_assets', ">=1.0.1"
# 分享功能
gem "social-share-button", ">= 0.0.3" #[!]
# To use Jbuilder templates for JSON
# pan> consider
#      https://github.com/rails/jbuilder/issues/56
gem 'blankslate','2.1.2.4'
gem 'jbuilder'

gem "sanitize"
# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# gem 'mongo-rails-instrumentation'
# gem "mongoid-eager-loading","0.3.1"  # deprecated!
# gem "mongoid_rails_migrations", "0.0.10"
# gem "cells","3.6.5"

# gem "dalli","1.1.2"

gem "redis","~>3"

# Vote 插件 for Mongoid
# gem 'voteable_mongo', path:'vendor/voteable_mongo'

# 分词
gem 'chinese_pinyin'
gem 'rmmseg-cpp-huacnlee'

# 用户系统
# 这个devise必须锁定版本！！我们定制的太多了
gem 'devise','2.1.0',path:'vendor/devise'
gem 'warden',path:'vendor/warden'
gem 'omniauth-weibo-oauth2'
#gem "omniauth-weibo", :git => 'git://github.com/pmq20/omniauth-weibo.git'
gem "omniauth-renren", :git => 'git://github.com/pmq20/omniauth-renren.git'
gem "omniauth-douban", :git => 'git://github.com/pmq20/omniauth-douban.git'
gem "omniauth-qq", :git => 'git://github.com/pmq20/omniauth-qq.git'
gem "omniauth-google-oauth2"
gem "omniauth-twitter"
gem 'omniauth-facebook'
gem 'omniauth-github'

# 邀请系统
# gem 'devise_invitable'

# 图片上传
gem 'carrierwave', '0.6.2'
gem 'carrierwave-grandcloud', :path=>'vendor/carrierwave-grandcloud'
gem 'mini_magick','3.3', :require => false

# 分页
gem 'will_paginate' #,:require=>'will_paginate/array'
gem "will_paginate_mongoid"
# gem 'memcache-client', '1.8.5'

# OAuth
# gem 'omniauth', '0.2.0'
# gem "oa-openid", '0.2.0'
# gem "omniauth_china", "0.0.6"

# 后台列表
# gem 'wice_grid', '3.0.0.pre1'

# 设置
gem 'settingslogic'

# 前端优化
# gem 'smurf-huacnlee', :require => "smurf"

# 表单
gem 'simple_form'

# 缓存管理
gem 'tagged-cache' #[!]

# PUT 颜色
gem 'colorize' #[!]

# 后台表格
# gem 'mongoid_wice_grid', '4.0.0', :require => "wice_grid"
# 表格
gem "googlecharts"

# Crontab 辅助
gem 'whenever' #[!]
# AWS SES
# gem "aws-ses", "0.4.2", :require => 'aws/ses'

# Background Jobs
gem "sidekiq", '>=2.3.0'
# gem "sidekiq-failures",:git=>'git://github.com/mhfs/sidekiq-failures.git'
gem 'sinatra', :require => nil
gem 'slim'
gem 'connection_pool'

#gem "resque", :require => "resque/server", :path => 'vendor/resque'
#gem 'resque-pool'
# gem "resque_mailer"

# Comet
# gem "juggernaut"

# Diff 内容并输出 HTML 格式
# gem "htmldiff", :git => "git://github.com/huacnlee/htmldiff.git"

gem "redis-search",:path=>'vendor/redis-search'
#gem 'redis-namespace'

gem "letter_opener"



gem 'php_serialize'
gem 'nokogiri','>=1.5.5'
gem 'redis-objects' #[!]
gem 'progressbar'
gem 'unicorn'


gem 'savon' #[!]
gem 'rest-client', path:'vendor/rest-client'
gem 'rails_autolink'



gem "oauth-plugin", ">= 0.4.0.pre1"


gem 'chronic' #[!]
=begin


Chronic.parse('tomorrow')
  #=> Mon Aug 28 12:00:00 PDT 2006

Chronic.parse('monday', :context => :past)
  #=> Mon Aug 21 12:00:00 PDT 2006

Chronic.parse('this tuesday 5:00')
  #=> Tue Aug 29 17:00:00 PDT 2006

Chronic.parse('this tuesday 5:00', :ambiguous_time_range => :none)
  #=> Tue Aug 29 05:00:00 PDT 2006

Chronic.parse('may 27th', :now => Time.local(2000, 1, 1))
  #=> Sat May 27 12:00:00 PDT 2000

Chronic.parse('may 27th', :guess => false)
  #=> Sun May 27 00:00:00 PDT 2007..Mon May 28 00:00:00 PDT 2007

Chronic.parse('6/4/2012', :endian_precedence => :little)
  #=> Fri Apr 06 00:00:00 PDT 2012

=end
gem 'yajl-ruby'

gem 'validate_url', '0.1.6'
gem 'to_xls', '~> 1.0.0'

gem 'sndacs'
# PDF
gem 'grim', :path=>'vendor/grim'#:git=>"git://github.com/sdegoeij/grim.git"#:git=>"git://github.com/llb0536/grim.git"
# memcached
gem 'dalli'

gem 'rails_kindeditor', '~> 0.3.0' #[!][!][!]
gem 'mechanize', '>=2.5.1'

gem "omnicontacts" #[!][!][!]
gem 'thin'

#Tracker Traffic source
gem 'search_terms'

gem 'selenium-webdriver'
# gem "Selenium", "~> 1.1.14"
#gem 'debugger'
gem 'exception_notification'
gem 'chronic_duration'
gem 'sixarm_ruby_magic_number_type'
gem 'xi'
gem 'curb'

## TEST Framework & Integration Framework
group :development do
  gem 'rb-inotify', :require => false if RUBY_PLATFORM =~ /linux/i
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'rb-fchange', :require => false if RUBY_PLATFORM =~ /mswin32|mingw/i
  gem 'terminal-notifier-guard' if RUBY_PLATFORM =~ /darwin/i
end
group :test,:development do
  # Framework & Integration Framework
  # gem 'cucumber-rails', :require => false
  gem "minitest",'>=4.2.0'
  gem 'minitest-rails'
  gem 'fakefs', :require => "fakefs/safe"
  ## User Experience
  gem 'capybara'
  # save_and_open_page
  gem 'launchy'
  ## Mongo
  # gem 'json_spec'
  # gem 'mongoid-rspec'
  # gem 'database_cleaner'
  
  ## 假数据fixtures
  gem 'ffaker'  ##有中文名字
  gem 'factory_girl_rails', :require => false
  # gem "mocha", :require => false
  
  ## 辅助作用的：simplecov生成报告
  gem 'turn'
  gem 'simplecov', :require => false 
  gem 'spork', '0.9.2'
  gem "spork-minitest", ">= 1.0.0.beta1"
  gem 'guard'
  gem 'guard-spork'
  gem 'guard-minitest', :git => 'git://github.com/pmq20/guard-minitest.git'
  gem 'turn'
  gem 'factory_girl'
end
gem 'tire'
gem 'gibbon'
gem 'pinyin_split'
gem 'multi_json','>=1.5.0'
gem 'intercom-rails'
gem 'cookiejar'
