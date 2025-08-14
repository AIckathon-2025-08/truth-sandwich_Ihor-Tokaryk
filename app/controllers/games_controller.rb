require_relative 'application_controller'

class GamesController < ApplicationController
  # Admin page - list all games and create new ones
  get '/' do
    @games = Game.all.includes(:user).order(created_at: :desc)
    @users = User.all.order(:last_name, :first_name)
    erb :'games/index'
  end
  
  # Show game details
  get '/:id' do
    @game = Game.find(params[:id])
    @vote_counts = @game.vote_counts
    erb :'games/show'
  rescue ActiveRecord::RecordNotFound
    halt 404, "Game not found"
  end
  
  # Create new game
  post '/' do
    # Deactivate any currently active games
    Game.where(active: true).update_all(active: false)
    
    @game = Game.new(
      user_id: params[:user_id],
      name: params[:name],
      position: params[:position],
      truth_1: params[:truth_1],
      truth_2: params[:truth_2],
      lie: params[:lie],
      active: true
    )
    
    if @game.save
      redirect "/games/#{@game.id}"
    else
      @games = Game.all.includes(:user).order(created_at: :desc)
      @users = User.all.order(:last_name, :first_name)
      erb :'games/index'
    end
  end
  
  # Activate/deactivate game
  put '/:id/toggle' do
    @game = Game.find(params[:id])
    
    if @game.active?
      @game.update(active: false)
    else
      # Deactivate all other games
      Game.where(active: true).update_all(active: false)
      @game.update(active: true)
    end
    
    redirect "/games/#{@game.id}"
  rescue ActiveRecord::RecordNotFound
    halt 404, "Game not found"
  end
  
  # Delete game
  delete '/:id' do
    @game = Game.find(params[:id])
    @game.destroy
    redirect '/games'
  rescue ActiveRecord::RecordNotFound
    halt 404, "Game not found"
  end
end
