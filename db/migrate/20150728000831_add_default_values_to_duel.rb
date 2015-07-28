class AddDefaultValuesToDuel < ActiveRecord::Migration
  def change
    change_column_default :duels, :turn, 1
    change_column_default :duels, :first_player_number, 1
    change_column_default :duels, :current_player_number, 1
    change_column_default :duels, :priority_player_number, 1
  end
end
