class DeclaredAttacker < ActiveRecord::Base
  belongs_to :duel
  belongs_to :entity

  belongs_to :target_player, class_name: "Player"

  validates :duel, presence: true
  validates :entity, presence: true
  validates :target_player, presence: true

end
