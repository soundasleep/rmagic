class AddTurnPlayedToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :turn_played, :integer
  end
end
