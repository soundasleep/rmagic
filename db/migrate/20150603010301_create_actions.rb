class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.references :entity, index: true, foreign_key: true
      t.integer :entity_action
      t.references :player, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
