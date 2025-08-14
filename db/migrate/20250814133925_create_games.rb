class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :position, null: false
      t.text :truth_1, null: false
      t.text :truth_2, null: false
      t.text :lie, null: false
      t.boolean :active, default: false
      t.timestamps
    end
    
    create_table :votes do |t|
      t.references :game, null: false, foreign_key: true
      t.references :voter, null: false, foreign_key: { to_table: :users }
      t.string :selected_statement, null: false # truth_1, truth_2, or lie
      t.timestamps
    end
    
    add_index :votes, [:game_id, :voter_id], unique: true
    add_index :games, :active
  end
end
