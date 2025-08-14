require 'sinatra/activerecord'

class Vote < ActiveRecord::Base
  belongs_to :game
  belongs_to :voter, class_name: 'User'
  
  validates :selected_statement, presence: true
  validates :selected_statement, inclusion: { in: ['truth_1', 'truth_2', 'lie'] }
  validates :game_id, uniqueness: { scope: :voter_id, message: "You can only vote once per game" }
end
