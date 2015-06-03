class CreateBattlefields < ActiveRecord::Migration
  def change
    create_table :battlefields do |t|
      t.references :player, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
