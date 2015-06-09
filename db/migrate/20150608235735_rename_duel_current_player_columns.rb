class RenameDuelCurrentPlayerColumns < ActiveRecord::Migration
  def change
    change_table :duels do |t|
      t.rename :current_player, :current_player_number
      t.rename :priority_player, :priority_player_number
      t.rename :first_player, :first_player_number
      t.rename :phase, :phase_number
    end
  end
end
