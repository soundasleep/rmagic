class CreateGraveyards < ActiveRecord::Migration
  def change
    create_table :graveyards do |t|
      t.references :player, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true
      t.integer :order

      t.timestamps null: false
    end
  end
end
