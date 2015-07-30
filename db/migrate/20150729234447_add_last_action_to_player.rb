class AddLastActionToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :last_action, :datetime
  end
end
