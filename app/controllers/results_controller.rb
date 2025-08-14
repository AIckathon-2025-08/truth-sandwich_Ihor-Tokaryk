require_relative 'application_controller'

class ResultsController < ApplicationController
  # Show live results for current active game or most recent game
  get '/' do
    @game = Game.current_active || Game.order(created_at: :desc).first
    
    if @game.nil?
      erb :'results/no_active_game'
    else
      @vote_counts = @game.vote_counts
      @total_votes = @game.total_votes
      @statements = @game.statements_for_results
      @show_lie = !@game.active? # Only show lie when game is inactive
      erb :'results/index'
    end
  end
  
  # API endpoint for live updates (returns JSON)
  get '/api' do
    content_type :json
    
    @game = Game.current_active || Game.order(created_at: :desc).first
    
    if @game.nil?
      { active: false }.to_json
    else
      vote_counts = @game.vote_counts
      statements = @game.statements_for_results
      
      {
        active: true,
        game: {
          id: @game.id,
          name: @game.name,
          position: @game.position,
          active: @game.active?,
          statements: statements,
          vote_counts: vote_counts,
          total_votes: @game.total_votes,
          show_lie: !@game.active? # Only show lie when game is inactive
        }
      }.to_json
    end
  end
end
