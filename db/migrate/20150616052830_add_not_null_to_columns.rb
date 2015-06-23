class AddNotNullToColumns < ActiveRecord::Migration
  def change
    [:battlefields, :decks, :graveyards, :hands].each do |table|
      change_column_null table, :player_id, false
      change_column_null table, :entity_id, false
    end
  end
end
