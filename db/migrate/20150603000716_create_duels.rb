class CreateDuels < ActiveRecord::Migration
  def change
    create_table :duels do |t|
      t.references :player1, index: true, foreign_key: true
      t.references :player2, index: true, foreign_key: true
      t.integer :current_player
      t.integer :phase

      t.timestamps null: false
    end
  end
end
