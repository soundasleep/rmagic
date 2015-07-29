class AddFinalTurnToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :final_turn, :number
  end
end
