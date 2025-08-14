class AddImageToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :image_filename, :string
  end
end
