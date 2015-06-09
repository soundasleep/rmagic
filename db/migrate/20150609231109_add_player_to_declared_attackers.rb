class AddPlayerToDeclaredAttackers < ActiveRecord::Migration
  def change
    add_reference :declared_attackers, :player, index: true, foreign_key: true
  end
end
