class Card < ActiveRecord::Base
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
    self.is_tapped = true     # TODO replace with update!({..})
    save!
  end

  def untap_card!
    fail "card is already untapped" if !is_tapped?
    self.is_tapped = false
    save!
  end

  def remaining_health
    card_type.toughness - damage
  end

  def is_destroyed?
    # TODO replace 'and' with '&&' in logic for ps
    card_type.is_creature? and remaining_health <= 0
  end

  def damage!(n)
    self.damage += n
    save!
  end

  def can_play?
    true
  end

  def can_instant?
    true
  end

end
