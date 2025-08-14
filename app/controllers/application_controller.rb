require 'sinatra'
require 'sinatra/activerecord'

class ApplicationController < Sinatra::Base
  # Configure Sinatra to look for views in app/views directory
  set :views, 'app/views'
  
  # Enable static file serving from public directory
  set :public_folder, 'public'
  set :static, true
  
  # Database configuration
  if ENV['DATABASE_URL']
    set :database, ENV['DATABASE_URL']
  else
    set :database_file, 'config/database.yml'
  end
  
  # Enable sessions if needed
  enable :sessions
  
  # Enable method override for PUT and DELETE requests
  enable :method_override
  
  # Set up any common before filters
  before do
    # Add any common setup here
  end
end
