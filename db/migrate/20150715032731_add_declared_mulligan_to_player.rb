class AddDeclaredMulliganToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :declared_mulligan, :boolean
  end
end
