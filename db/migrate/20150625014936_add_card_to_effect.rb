class AddCardToEffect < ActiveRecord::Migration
  def change
    add_reference :effects, :card, index: true, foreign_key: true
  end
end
