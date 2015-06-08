class AddManaToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :mana_blue, :integer
    add_column :players, :mana_green, :integer
    add_column :players, :mana_red, :integer
    add_column :players, :mana_white, :integer
    add_column :players, :mana_black, :integer
    add_column :players, :mana_colourless, :integer
  end
end
