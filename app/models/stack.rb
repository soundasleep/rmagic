class Stack < ActiveRecord::Base
  include ZoneCard

  belongs_to :duel
  belongs_to :card
  belongs_to :player

  # do not dependent: :destroy - the references are needed when resolving the stack
  # TODO add another explicit :destroy instead
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

end
