class SetNotNullOnDeclaredMulliganOnPlayer < ActiveRecord::Migration
  def change
    change_column_null :players, :declared_mulligan, false
  end
end
