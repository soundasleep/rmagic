class Graveyard < ActiveRecord::Base
  include ZoneCard

  belongs_to :player
  belongs_to :card

  # TODO   validates :order, presence: true
  validates :player, :card, presence: true
  validates :card, uniqueness: true

  def zone
    GraveyardZone.new
  end

end
