class Graveyard < ActiveRecord::Base
  include ZoneCard

  belongs_to :player
  belongs_to :card

  validates :order, presence: true
  validates :player, :card, presence: true
  # TODO add uniqueness constraint to schema.rb
  validates :card, uniqueness: true

  def zone
    GraveyardZone.new
  end

end
