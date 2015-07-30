class Battlefield < ActiveRecord::Base
  include ZoneCard

  belongs_to :player
  belongs_to :card

  validates :player, :card, presence: true
  validates :card, uniqueness: true

  def zone
    BattlefieldZone.new
  end

  # we can't use scopes; they do not clear caches when the underlying
  # model is reloaded :(

  def is_visible_to?(player)
    true
  end

end
