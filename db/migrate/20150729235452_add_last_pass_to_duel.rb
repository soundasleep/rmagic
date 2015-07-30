class AddLastPassToDuel < ActiveRecord::Migration
  def change
    add_column :duels, :last_pass, :datetime
  end
end
