class AddDamageToActionTarget < ActiveRecord::Migration
  def change
    add_column :action_targets, :damage, :integer
  end
end
