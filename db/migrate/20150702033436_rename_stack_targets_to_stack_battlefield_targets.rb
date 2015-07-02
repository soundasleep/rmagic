class RenameStackTargetsToStackBattlefieldTargets < ActiveRecord::Migration
  def change
    rename_table :stack_targets, :stack_battlefield_targets
  end
end
