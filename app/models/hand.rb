class Hand < ActiveRecord::Base
  include ZoneCard

  belongs_to :player
  belongs_to :card

  validates :player, :card, presence: true
  # TODO add uniqueness constraint to schema.rb
  validates :card, uniqueness: true

  def zone
    HandZone.new
  end

end
