class AddAttachedToToCard < ActiveRecord::Migration
  def change
    add_reference :cards, :attached_to, index: true, foreign_key: true
  end
end
