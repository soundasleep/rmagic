class AddTurnToDuel < ActiveRecord::Migration
  def change
    add_column :duels, :turn, :integer
  end
end
