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
    
    # Handle image upload
    if params[:image] && params[:image][:tempfile]
      unless @user.save_uploaded_image(params[:image])
        @user.errors.add(:image, "Invalid image file. Please upload a JPG, PNG, or GIF file.")
      end
    end
    
    if @user.errors.empty? && @user.save
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
    
    # Handle image upload
    if params[:image] && params[:image][:tempfile]
      unless @user.save_uploaded_image(params[:image])
        @user.errors.add(:image, "Invalid image file. Please upload a JPG, PNG, or GIF file.")
      end
    end
    
    user_params = {
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      position: params[:position],
      admin: params[:admin] == 'on'
    }
    
    if @user.errors.empty? && @user.update(user_params)
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
  
  # Delete user image
  delete '/:id/image' do
    @user = User.find(params[:id])
    @user.delete_image
    redirect "/users/#{@user.id}"
  rescue ActiveRecord::RecordNotFound
    halt 404, "User not found"
  end
end
