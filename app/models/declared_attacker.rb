class DeclaredAttacker < ActiveRecord::Base
  belongs_to :duel
  belongs_to :card
  belongs_to :target_player, class_name: "Player"
  belongs_to :player, class_name: "Player"

  validates :duel, presence: true
  validates :card, presence: true
  validates :target_player, presence: true
  validates :player, presence: true

end
