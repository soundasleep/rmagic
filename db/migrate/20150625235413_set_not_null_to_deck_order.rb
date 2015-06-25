class SetNotNullToDeckOrder < ActiveRecord::Migration
  def change
    change_column_null :decks, :order, false
  end
end
