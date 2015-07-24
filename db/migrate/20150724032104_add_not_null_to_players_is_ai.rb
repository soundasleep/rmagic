class AddNotNullToPlayersIsAi < ActiveRecord::Migration
  def change
    change_column_default :players, :is_ai, false
    change_column_null :players, :is_ai, false
  end
end
