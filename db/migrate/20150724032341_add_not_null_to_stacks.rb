class AddNotNullToStacks < ActiveRecord::Migration
  def change
    change_column_null :stacks, :duel_id, false
    change_column_null :stacks, :card_id, false
    change_column_null :stacks, :order, false
    change_column_null :stacks, :player_id, false
    change_column_null :stacks, :key, false
  end
end
