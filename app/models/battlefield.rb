class Battlefield < ActiveRecord::Base
  belongs_to :player
  belongs_to :card

  validates :player, :card, presence: true
  validates :card, uniqueness: true

  def zone
    BattlefieldZone.new
  end

  scope :creatures, -> { select { |b| b.card.card_type.is_creature? } }
  scope :lands, -> { select { |b| b.card.card_type.is_land? } }

end
