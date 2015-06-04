class AddGlobalActionToAction < ActiveRecord::Migration
  def change
    add_column :actions, :global_action, :string
  end
end
