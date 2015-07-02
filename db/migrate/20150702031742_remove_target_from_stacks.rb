class RemoveTargetFromStacks < ActiveRecord::Migration
  def change
    remove_reference :stacks, :target, index: true, foreign_key: true
  end
end
