class Battlefield < ActiveRecord::Base
  belongs_to :player
  belongs_to :entity

  validates :player, :entity, presence: true
  validates :entity, uniqueness: true

  def zone
    BattlefieldZone.new
  end

end
