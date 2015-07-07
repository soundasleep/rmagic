class Stack < ActiveRecord::Base
  include ZoneCard

  belongs_to :duel
  belongs_to :card
  belongs_to :player

  has_many :battlefield_targets, class_name: "StackBattlefieldTarget", dependent: :destroy
  has_many :graveyard_targets, class_name: "StackGraveyardTarget", dependent: :destroy
  has_many :player_targets, class_name: "StackPlayerTarget", dependent: :destroy

  validates :order, presence: true
  validates :duel, :card, :player, presence: true
  validates :card, uniqueness: true
  validates :key, format: { with: /\A[A-Z_a-z]+\z/, message: "has an invalid action key" }

  def zone
    StackZone.new
  end

  # TODO temporary to match up with Stack - we should create an Actionable interface
  def source
    card
  end

end
