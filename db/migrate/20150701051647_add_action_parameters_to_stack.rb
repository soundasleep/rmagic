class AddActionParametersToStack < ActiveRecord::Migration
  def change
    add_column :stacks, :action_key, :string
    add_reference :stacks, :target, index: true, foreign_key: true
  end
end
