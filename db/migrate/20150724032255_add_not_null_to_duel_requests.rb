class AddNotNullToDuelRequests < ActiveRecord::Migration
  def change
    change_column_null :duel_requests, :user_id, false
    change_column_null :duel_requests, :premade_deck_id, false
  end
end
