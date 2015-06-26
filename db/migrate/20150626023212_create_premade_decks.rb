class CreatePremadeDecks < ActiveRecord::Migration
  def change
    create_table :premade_decks do |t|
      t.string :name, null: false
      t.references :created_by, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
