class Graveyard < ActiveRecord::Base
  belongs_to :player
  belongs_to :entity

  validates :player, :entity, presence: true
  validates :entity, uniqueness: true

  # TODO add db constraint in a rails migration nil=false for all presence: true

  def zone
    GraveyardZone.new
  end

end
