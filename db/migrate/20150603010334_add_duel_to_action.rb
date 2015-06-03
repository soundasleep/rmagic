class AddDuelToAction < ActiveRecord::Migration
  def change
    add_reference :actions, :duel, index: true, foreign_key: true
  end
end
