class SetNotNullOnPreamdeDeckCards < ActiveRecord::Migration
  def change
    change_column_null :premade_deck_cards, :premade_deck_id, false
  end
end
