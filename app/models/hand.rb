class Hand < ActiveRecord::Base
  belongs_to :player
  belongs_to :card

  validates :player, :card, presence: true
  validates :card, uniqueness: true

  delegate :to_text, to: :card

  def zone
    HandZone.new
  end

end
