class AddTargetPlayerToDeclaredAttackers < ActiveRecord::Migration
  def change
    add_reference :declared_attackers, :target_player, index: true, foreign_key: true
  end
end
