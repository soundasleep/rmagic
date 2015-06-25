class SetNotNullOnCardEffectId < ActiveRecord::Migration
  def change
    change_column_null :effects, :card_id, false
  end
end
