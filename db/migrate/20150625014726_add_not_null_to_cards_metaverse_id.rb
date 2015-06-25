class AddNotNullToCardsMetaverseId < ActiveRecord::Migration
  def change
    change_column_null :cards, :metaverse_id, false
  end
end
