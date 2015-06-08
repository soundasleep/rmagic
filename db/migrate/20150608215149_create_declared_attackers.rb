class CreateDeclaredAttackers < ActiveRecord::Migration
  def change
    create_table :declared_attackers do |t|
      t.references :duel, index: true, foreign_key: true
      t.references :entity, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
