class AddPlayerToStack < ActiveRecord::Migration
  def change
    add_reference :stacks, :player, index: true, foreign_key: true
  end
end
