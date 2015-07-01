class RenameStackActionKeytoKey < ActiveRecord::Migration
  def change
    change_table :stacks do |t|
      t.rename :action_key, :key
    end
  end
end
