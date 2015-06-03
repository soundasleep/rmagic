class CreateActionTargets < ActiveRecord::Migration
  def change
    create_table :action_targets do |t|
      t.references :entity, index: true, foreign_key: true
      t.references :action, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
