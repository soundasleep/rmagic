class Deck < ActiveRecord::Base
  include ZoneCard

  belongs_to :player
  belongs_to :card

  validates :player, :card, presence: true
  validates :card, uniqueness: true

  def zone
    DeckZone.new
  end

end
