class CreateStacks < ActiveRecord::Migration
  def change
    create_table :stacks do |t|
      t.references :duel, index: true, foreign_key: true
      t.references :card, index: true, foreign_key: true
      t.integer :order

      t.timestamps null: false
    end
  end
end
