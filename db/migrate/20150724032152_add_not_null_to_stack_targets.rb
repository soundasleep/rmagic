class AddNotNullToStackTargets < ActiveRecord::Migration
  def change
    change_column_null :stack_battlefield_targets, :stack_id, false
    change_column_null :stack_battlefield_targets, :target_id, false

    change_column_null :stack_graveyard_targets, :stack_id, false
    change_column_null :stack_graveyard_targets, :target_id, false

    change_column_null :stack_player_targets, :stack_id, false
    change_column_null :stack_player_targets, :target_id, false
  end
end
