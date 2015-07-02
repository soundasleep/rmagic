class AddTargetToStack < ActiveRecord::Migration
  def change
    remove_reference :stacks, :target
    add_reference :stacks, :target, index: true, foreign_key: true
  end
end
