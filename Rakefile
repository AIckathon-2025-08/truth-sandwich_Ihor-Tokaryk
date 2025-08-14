require "sinatra/activerecord"
require "sinatra/activerecord/rake"

# Configure the database
ENV['DATABASE_URL'] ||= "sqlite3:db/development.sqlite3"

namespace :db do
  task :load_config do
    require "./app"
  end
end
