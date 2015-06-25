class RemoveTokenTypeFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :token_type
    remove_column :cards, :effect_type
  end
end
