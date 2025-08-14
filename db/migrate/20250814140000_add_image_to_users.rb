class AddImageToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :image_filename, :string
  end
end
