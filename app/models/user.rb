require 'sinatra/activerecord'
require 'securerandom'
require 'fileutils'

class User < ActiveRecord::Base
  has_many :games, dependent: :destroy
  has_many :votes, foreign_key: 'voter_id', dependent: :destroy
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :position, presence: true
  
  before_destroy :delete_image_file
  
  def full_name
    "#{first_name} #{last_name}"
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
