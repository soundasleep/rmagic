class Battlefield < ActiveRecord::Base
  include ZoneCard

  belongs_to :player
  belongs_to :card

  validates :player, :card, presence: true
  # TODO add uniqueness constraint to schema.rb
  validates :card, uniqueness: true

  def zone
    BattlefieldZone.new
  end

  # we can't use scopes; they do not clear caches when the underlying
  # model is reloaded :(

end
