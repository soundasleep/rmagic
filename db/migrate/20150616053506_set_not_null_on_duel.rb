class SetNotNullOnDuel < ActiveRecord::Migration
  def change
    change_column_null :duels, :player1_id, false
    change_column_null :duels, :player2_id, false
    change_column_null :duels, :current_player_number, false
    change_column_null :duels, :phase_number, false
    change_column_null :duels, :priority_player_number, false
    change_column_null :duels, :turn, false
    change_column_null :duels, :first_player_number, false
  end
end
