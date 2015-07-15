class AddIsAiToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_ai, :boolean
  end
end
