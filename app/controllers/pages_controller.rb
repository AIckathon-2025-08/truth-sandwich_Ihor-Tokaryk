require_relative 'application_controller'

class PagesController < ApplicationController
  get '/' do
    erb :index
  end
  
  # Add more page routes here as needed
  # get '/about' do
  #   erb :about
  # end
end
