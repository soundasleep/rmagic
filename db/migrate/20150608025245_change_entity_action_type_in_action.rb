class ChangeEntityActionTypeInAction < ActiveRecord::Migration
  def change
    change_column :actions, :entity_action, :text
  end
end
