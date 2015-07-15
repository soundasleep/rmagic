class SetDefaultIsAiOnUser < ActiveRecord::Migration
  def change
    change_column_default :users, :is_ai, false
  end
end
