class CreateDeclaredDefenders < ActiveRecord::Migration
  def change
    create_table :declared_defenders do |t|
      t.references :duel, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true
      t.references :target, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
