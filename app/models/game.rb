require 'sinatra/activerecord'
require 'securerandom'
require 'fileutils'

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
  
  before_destroy :delete_image_file
  
  def statements
    [
      { type: 'truth_1', text: truth_1 },
      { type: 'truth_2', text: truth_2 },
      { type: 'lie', text: lie }
    ].shuffle
  end
  
  def statements_for_results
    [
      { type: 'truth_1', text: truth_1 },
      { type: 'truth_2', text: truth_2 },
      { type: 'lie', text: lie }
    ]
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
  
  def image_url
    image_filename ? "/uploads/#{image_filename}" : nil
  end
  
  def has_image?
    !image_filename.nil? && !image_filename.empty?
  end
  
  def save_uploaded_image(uploaded_file)
    return false unless uploaded_file && uploaded_file[:filename]
    
    # Validate file type
    allowed_types = %w[.jpg .jpeg .png .gif .bmp]
    file_ext = File.extname(uploaded_file[:filename]).downcase
    return false unless allowed_types.include?(file_ext)
    
    # Generate unique filename
    unique_filename = "#{SecureRandom.uuid}#{file_ext}"
    upload_path = File.join('public', 'uploads', unique_filename)
    
    # Ensure uploads directory exists
    FileUtils.mkdir_p(File.dirname(upload_path))
    
    # Save the file
    File.open(upload_path, 'wb') do |file|
      file.write(uploaded_file[:tempfile].read)
    end
    
    # Delete old image if it exists
    delete_image_file if image_filename
    
    # Update the filename
    self.image_filename = unique_filename
    true
  rescue
    false
  end
  
  def delete_image
    delete_image_file
    self.image_filename = nil
    save
  end
  
  private
  
  def delete_image_file
    return unless image_filename
    
    file_path = File.join('public', 'uploads', image_filename)
    File.delete(file_path) if File.exist?(file_path)
  rescue
    # Log error but don't fail the operation
  end
end
