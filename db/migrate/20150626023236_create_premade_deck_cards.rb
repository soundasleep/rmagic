class CreatePremadeDeckCards < ActiveRecord::Migration
  def change
    create_table :premade_deck_cards do |t|
      t.references :premade_deck, index: true, foreign_key: true
      t.integer :metaverse_id, null: false

      t.timestamps null: false
    end
  end
end
