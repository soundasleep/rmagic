class ChangeDeclaredDefenderEntityToSource < ActiveRecord::Migration
  def change
    change_table :declared_defenders do |t|
      t.rename :entity_id, :source_id
    end
  end
end
