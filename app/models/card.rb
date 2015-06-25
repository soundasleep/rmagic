class Card < ActiveRecord::Base
  has_many :effects, dependent: :destroy

  validates :turn_played, presence: true
  validates :metaverse_id, presence: true

  validate :valid_card

  def valid_card
    if !card_type
      errors.add(:metaverse_id, "Could not find card #{metaverse_id}")
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

  delegate :to_text, :action_text, to: :card_type

  def can_tap?
    !is_tapped?
  end

  def can_untap?
    is_tapped?
  end

  def tap_card!
    fail "card is already tapped" if is_tapped?
    update! is_tapped: true
  end

  def untap_card!
    fail "card is already untapped" if !is_tapped?
    update! is_tapped: false
  end

  def remaining_health
    card_type.toughness - damage
  end

  def is_destroyed?
    card_type.is_creature? && remaining_health <= 0
  end

  def damage!(n)
    update! damage: damage + n
  end

  def can_play?
    true
  end

  def can_instant?
    true
  end

  def can_ability?
    true
  end

  def power
    effects.inject(card_type.power) { |n, effect| effect.effect_type.modify_power(n) }
  end

  def toughness
    effects.inject(card_type.toughness) { |n, effect| effect.effect_type.modify_toughness(n) }
  end

end
