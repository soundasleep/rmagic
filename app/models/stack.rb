class Stack < ActiveRecord::Base
  include ZoneCard

  belongs_to :duel
  belongs_to :card
  belongs_to :player

  # the references are needed when resolving the stack, so no dependent: declarations here
  # TODO destroy only deletes has_many and has_ones, so maybe this should be able to dependent: :destroy
  has_many :battlefield_targets, class_name: "StackBattlefieldTarget"
  has_many :graveyard_targets, class_name: "StackGraveyardTarget"
  has_many :player_targets, class_name: "StackPlayerTarget"

  validates :order, presence: true
  validates :duel, :card, :player, presence: true
  validates :card, uniqueness: true
  validates :key, format: { with: /\A[A-Z_a-z]+\z/, message: "has an invalid action key" }

  def zone
    StackZone.new
  end

  def source
    card
  end

  def is_visible_to?(player)
    true
  end

end
