class RenameEntityToCard < ActiveRecord::Migration
  def change
    rename_table :entities, :cards
  end
end
