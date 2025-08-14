require "sinatra/activerecord"
require "sinatra/activerecord/rake"

# Configure the database based on environment
ENV['RACK_ENV'] ||= 'development'
case ENV['RACK_ENV']
when 'production'
  ENV['DATABASE_URL'] ||= "sqlite3:db/production.sqlite3"
when 'test'
  ENV['DATABASE_URL'] ||= "sqlite3:db/test.sqlite3"
else
  ENV['DATABASE_URL'] ||= "sqlite3:db/development.sqlite3"
end

namespace :db do
  task :load_config do
    require "./app"
  end
end
