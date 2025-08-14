require 'sinatra/activerecord'

class User < ActiveRecord::Base
  has_many :games, dependent: :destroy
  has_many :votes, foreign_key: 'voter_id', dependent: :destroy
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :position, presence: true
  
  def full_name
    "#{first_name} #{last_name}"
  end
end
