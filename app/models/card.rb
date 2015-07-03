class Card < ActiveRecord::Base
  has_many :effects, dependent: :destroy

  validates :turn_played, presence: true
  validates :metaverse_id, presence: true

  validate :valid_card
  validate :valid_metaverse_id

  def valid_card
    if !card_type
      errors.add(:metaverse_id, "Could not find card #{metaverse_id}")
    end
  end

  def valid_metaverse_id
    if metaverse_id && metaverse_id <= 0
      errors.add(:metaverse_id, "Invalid metaverse ID #{metaverse_id}")
    end
  end

  before_validation :init

  def init
    self.is_tapped ||= false
    self.damage ||= 0
  end

  def card_type
    @card ||= CardUniverse.new.find_metaverse(metaverse_id)
  end

  def to_text
    if card_type.is_creature?
      "#{card_type.to_text} ( #{power} / #{toughness} )"
    else
      card_type.to_text
    end
  end

  delegate :action_text, to: :card_type

  def tap_card!
    fail "card is already tapped" if is_tapped?
    update! is_tapped: true
  end

  def untap_card!
    fail "card is already untapped" if !is_tapped?
    update! is_tapped: false
  end

  def remaining_health
    toughness - damage
  end

  def is_destroyed?
    card_type.is_creature? && remaining_health <= 0
  end

  # TODO consider moving into service (can introduce locking etc)
  def damage!(n)
    update! damage: damage + n
  end

  def power
    effects.inject(card_type.power) { |n, effect| effect.effect_type.modify_power(n) }
  end

  def toughness
    effects.inject(card_type.toughness) { |n, effect| effect.effect_type.modify_toughness(n) }
  end

  def next_effect_order
    return 1 if effects.empty?
    effects.map(&:order).max + 1
  end

end
