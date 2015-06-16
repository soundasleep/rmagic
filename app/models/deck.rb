class Deck < ActiveRecord::Base
  belongs_to :player
  belongs_to :entity

  validates :player, :entity, presence: true
  validates :entity, uniqueness: true

  def zone
    DeckZone.new
  end

end
