require_relative 'application_controller'

class VotingController < ApplicationController
  # Show voting page for current active game
  get '/' do
    @game = Game.current_active
    @users = User.all.order(:last_name, :first_name)
    
    if @game.nil?
      erb :'voting/no_active_game'
    else
      erb :'voting/index'
    end
  end
  
  # Submit vote
  post '/' do
    @game = Game.current_active
    halt 404, "No active game" if @game.nil?
    
    voter_id = params[:voter_id]
    selected_statement = params[:selected_statement]
    
    halt 400, "Missing voter or statement" if voter_id.blank? || selected_statement.blank?
    
    @vote = Vote.new(
      game: @game,
      voter_id: voter_id,
      selected_statement: selected_statement
    )
    
    if @vote.save
      redirect '/voting/thanks'
    else
      @users = User.all.order(:last_name, :first_name)
      @error = @vote.errors.full_messages.join(', ')
      erb :'voting/index'
    end
  end
  
  # Thank you page after voting
  get '/thanks' do
    erb :'voting/thanks'
  end
end
