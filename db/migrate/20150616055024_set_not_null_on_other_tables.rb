class SetNotNullOnOtherTables < ActiveRecord::Migration
  def change
    change_column_null :action_log_targets, :entity_id, false
    change_column_null :action_log_targets, :action_log_id, false

    change_column_null :action_logs, :duel_id, false

    change_column_null :declared_attackers, :duel_id, false
    change_column_null :declared_attackers, :entity_id, false
    change_column_null :declared_attackers, :target_player_id, false
    change_column_null :declared_attackers, :player_id, false

    change_column_null :declared_defenders, :duel_id, false
    change_column_null :declared_defenders, :source_id, false
    change_column_null :declared_defenders, :target_id, false

    change_column_null :entities, :is_tapped, false
    change_column_null :entities, :damage, false
    change_column_null :entities, :turn_played, false
  end
end
