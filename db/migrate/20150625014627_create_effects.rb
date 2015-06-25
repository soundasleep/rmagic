class CreateEffects < ActiveRecord::Migration
  def change
    create_table :effects do |t|
      t.integer :effect_id, null: false
      t.integer :order, null: false

      t.timestamps null: false
    end

    add_index :effects, :effect_id
    add_index :effects, :order
  end
end
