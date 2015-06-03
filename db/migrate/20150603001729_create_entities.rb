class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.integer :metaverse_id
      t.integer :token_type
      t.integer :effect_type

      t.timestamps null: false
    end
  end
end
