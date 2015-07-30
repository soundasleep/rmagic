class AddPhaseNumberToActionLog < ActiveRecord::Migration
  def change
    add_column :action_logs, :phase_number, :integer
  end
end
