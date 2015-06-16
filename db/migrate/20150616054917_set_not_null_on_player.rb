class SetNotNullOnPlayer < ActiveRecord::Migration
  def change
    change_column_null :players, :name, false
    change_column_null :players, :life, false
    change_column_null :players, :mana_blue, false
    change_column_null :players, :mana_green, false
    change_column_null :players, :mana_red, false
    change_column_null :players, :mana_white, false
    change_column_null :players, :mana_black, false
    change_column_null :players, :mana_colourless, false
  end
end
