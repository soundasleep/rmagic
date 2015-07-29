class AddWonToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :won, :boolean
    add_column :players, :lost, :boolean
    add_column :players, :drawn, :boolean

    change_column_default :players, :won, false
    change_column_default :players, :lost, false
    change_column_default :players, :drawn, false

    change_column_null :players, :won, false
    change_column_null :players, :lost, false
    change_column_null :players, :drawn, false
  end
end
