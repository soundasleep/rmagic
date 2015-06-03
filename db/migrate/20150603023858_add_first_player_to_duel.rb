class AddFirstPlayerToDuel < ActiveRecord::Migration
  def change
    add_column :duels, :first_player, :integer
  end
end
