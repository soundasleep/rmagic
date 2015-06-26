class SetNotNullToGraveyardOrder < ActiveRecord::Migration
  def change
    change_column_null :graveyards, :order, false
  end
end
