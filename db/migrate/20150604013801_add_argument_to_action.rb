class AddArgumentToAction < ActiveRecord::Migration
  def change
    add_column :actions, :argument, :integer
  end
end
