class AddIsTappedToEntity < ActiveRecord::Migration
  def change
    add_column :entities, :is_tapped, :boolean
  end
end
