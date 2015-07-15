class SetDefaultDeclaredMulliganOnPlayer < ActiveRecord::Migration
  def change
    change_column_default :players, :declared_mulligan, false
  end
end
