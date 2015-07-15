class AddMulligansToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :mulligans, :integer
  end
end
