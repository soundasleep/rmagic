class AddUniquenessDatabaseConstraints < ActiveRecord::Migration
  def change
    remove_index :battlefields, [:card_id]
    remove_index :decks, [:card_id]
    remove_index :graveyards, [:card_id]
    remove_index :hands, [:card_id]
    remove_index :stacks, [:card_id]

    add_index :battlefields, [:card_id], :unique => true
    add_index :decks, [:card_id], :unique => true
    add_index :graveyards, [:card_id], :unique => true
    add_index :hands, [:card_id], :unique => true
    add_index :stacks, [:card_id], :unique => true
  end
end
