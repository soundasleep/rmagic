class Stack < ActiveRecord::Base
  include ZoneCard

  belongs_to :duel
  belongs_to :card

  validates :order, presence: true
  validates :duel, :card, presence: true
  validates :card, uniqueness: true

  def zone
    StackZone.new
  end

end
