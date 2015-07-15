class SetDefaultMulligansOnPlayer < ActiveRecord::Migration
  def change
    change_column_default :players, :mulligans, 0
  end
end
