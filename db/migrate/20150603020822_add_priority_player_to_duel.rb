class AddPriorityPlayerToDuel < ActiveRecord::Migration
  def change
    add_column :duels, :priority_player, :integer
  end
end
