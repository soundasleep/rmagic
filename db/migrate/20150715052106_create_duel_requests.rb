class CreateDuelRequests < ActiveRecord::Migration
  def change
    create_table :duel_requests do |t|
      t.references :user, index: true, foreign_key: true
      t.references :premade_deck, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
