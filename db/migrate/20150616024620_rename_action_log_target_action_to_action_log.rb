class RenameActionLogTargetActionToActionLog < ActiveRecord::Migration
  def change
    change_table :action_log_targets do |t|
      t.rename :action_id, :action_log_id
    end
  end
end
