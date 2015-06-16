class Graveyard < ActiveRecord::Base
  belongs_to :player
  belongs_to :entity

  # TODO collapse
  validates :player, presence: true
  validates :entity, presence: true, uniqueness: true

  # TODO add db constraint in a rails migration nil=false for all presence: true

  def zone
    GraveyardZone.new
  end

end
