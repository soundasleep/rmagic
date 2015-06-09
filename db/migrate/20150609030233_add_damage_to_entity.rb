class AddDamageToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :damage, :integer
  end
end
