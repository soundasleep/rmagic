class CreateStackGraveyardTargets < ActiveRecord::Migration
  def change
    create_table :stack_graveyard_targets do |t|
      t.references :stack, index: true, foreign_key: true
      t.references :target, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
