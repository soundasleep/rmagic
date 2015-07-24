class AddDefaultValuesToPlayer < ActiveRecord::Migration
  def change
    change_column_default :players, :life, 20
    change_column_default :players, :mana_blue, 0
    change_column_default :players, :mana_green, 0
    change_column_default :players, :mana_red, 0
    change_column_default :players, :mana_white, 0
    change_column_default :players, :mana_black, 0
    change_column_default :players, :mana_colourless, 0
  end
end
