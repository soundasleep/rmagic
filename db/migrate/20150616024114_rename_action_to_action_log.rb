class RenameActionToActionLog < ActiveRecord::Migration
  def change
    rename_table :actions, :action_logs
    rename_table :action_targets, :action_log_targets
  end
end
