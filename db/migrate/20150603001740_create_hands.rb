class CreateHands < ActiveRecord::Migration
  def change
    create_table :hands do |t|
      t.references :player, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
