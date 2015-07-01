class Stack < ActiveRecord::Base
  include ZoneCard

  belongs_to :duel
  belongs_to :card
  belongs_to :player

  has_one :target, class_name: "Card", dependent: :destroy

  validates :order, presence: true
  validates :duel, :card, :player, presence: true
  validates :card, uniqueness: true

  def zone
    StackZone.new
  end

end
