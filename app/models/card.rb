class Card < ActiveRecord::Base
  has_many :effects, dependent: :destroy
  has_many :enchantments, class_name: "Card", foreign_key: :attached_to_id, dependent: :destroy

  has_many :battlefield, dependent: :destroy
  has_many :graveyard, dependent: :destroy
  has_many :deck, dependent: :destroy
  has_many :hand, dependent: :destroy

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
    # storing the CardUniverse in a class instance variable didn't make a performance impact
    @card ||= CardUniverse.new.find_metaverse(metaverse_id)
  end

  def to_text
    if card_type.is_creature?
      "#{card_type.to_text} (#{power} / #{toughness})"
    else
      card_type.to_text
    end
  end

  delegate :action_text, to: :card_type

  def attached_to?
    attached_to_id?
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
    toughness - damage
  end

  def is_destroyed?
    card_type.is_creature? && remaining_health <= 0
  end

  def power
    (effects + enchantment_cards).inject(card_type.power) { |n, effect| effect.modify_power(n) }
  end

  def toughness
    (effects + enchantment_cards).inject(card_type.toughness) { |n, effect| effect.modify_toughness(n) }
  end

  def next_effect_order
    return 1 if effects.empty?
    effects.map(&:order).max + 1
  end

  def card
    self
  end

  def controller
    [battlefield, graveyard, hand, deck].each do |zone|
      return zone.first.player if zone.any?
    end
    nil
  end

  private

    def enchantment_cards
      enchantments.map(&:card_type)
    end

end
