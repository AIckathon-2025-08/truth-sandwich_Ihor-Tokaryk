require 'sinatra/activerecord'

class Game < ActiveRecord::Base
  belongs_to :user
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :voter
  
  validates :name, presence: true
  validates :position, presence: true
  validates :truth_1, presence: true
  validates :truth_2, presence: true
  validates :lie, presence: true
  
  scope :active, -> { where(active: true) }
  
  def statements
    [
      { type: 'truth_1', text: truth_1 },
      { type: 'truth_2', text: truth_2 },
      { type: 'lie', text: lie }
    ].shuffle
  end
  
  def vote_counts
    {
      truth_1: votes.where(selected_statement: 'truth_1').count,
      truth_2: votes.where(selected_statement: 'truth_2').count,
      lie: votes.where(selected_statement: 'lie').count
    }
  end
  
  def total_votes
    votes.count
  end
  
  def voted_by?(user)
    votes.exists?(voter: user)
  end
  
  def self.current_active
    active.first
  end
end
