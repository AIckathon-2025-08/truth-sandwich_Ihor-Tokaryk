require_relative 'application_controller'

class UsersController < ApplicationController
  # Index - List all users
  get '/' do
    @users = User.all.order(:last_name, :first_name)
    erb :'users/index'
  end
  
  # New - Show form for creating a new user (must come before /:id)
  get '/new' do
    @user = User.new
    erb :'users/new'
  end
  
  # Show - Display a specific user
  get '/:id' do
    @user = User.find(params[:id])
    erb :'users/show'
  rescue ActiveRecord::RecordNotFound
    halt 404, "User not found"
  end
  
  # Create - Handle form submission for new user
  post '/' do
    @user = User.new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      position: params[:position],
      admin: params[:admin] == 'on'
    )
    
    if @user.save
      redirect "/users/#{@user.id}"
    else
      erb :'users/new'
    end
  end
  
  # Edit - Show form for editing an existing user
  get '/:id/edit' do
    @user = User.find(params[:id])
    erb :'users/edit'
  rescue ActiveRecord::RecordNotFound
    halt 404, "User not found"
  end
  
  # Update - Handle form submission for updating user
  put '/:id' do
    @user = User.find(params[:id])
    
    if @user.update(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      position: params[:position],
      admin: params[:admin] == 'on'
    )
      redirect "/users/#{@user.id}"
    else
      erb :'users/edit'
    end
  rescue ActiveRecord::RecordNotFound
    halt 404, "User not found"
  end
  
  # Delete - Handle deletion of a user
  delete '/:id' do
    @user = User.find(params[:id])
    @user.destroy
    redirect '/users'
  rescue ActiveRecord::RecordNotFound
    halt 404, "User not found"
  end
end
