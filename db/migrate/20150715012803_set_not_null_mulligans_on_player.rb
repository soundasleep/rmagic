class SetNotNullMulligansOnPlayer < ActiveRecord::Migration
  def change
    change_column_null :players, :mulligans, false
  end
end
