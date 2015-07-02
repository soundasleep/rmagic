class RemoveTargetFromStack < ActiveRecord::Migration
  def change
    remove_column :stacks, :target
  end
end
