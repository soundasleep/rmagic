class Entity < ActiveRecord::Base
  validates :turn_played, presence: true

  after_initialize :init

  def init
    self.is_tapped ||= false
    self.damage ||= 0
  end

  def find_card
    return CardUniverse.new.find_metaverse(metaverse_id) if metaverse_id

    fail "Could not find card #{metaverse_id}"
  end

  def to_text
    find_card.to_text
  end

  def action_text(action_id)
    find_card.action_text(action_id)
  end

  def tap_card!
    fail "card is already tapped" unless !is_tapped?
    self.is_tapped = true
    save!
  end

  def untap_card!
    fail "card is already untapped" unless is_tapped?
    self.is_tapped = false
    save!
  end

  def remaining_health
    find_card.toughness - damage
  end

  def is_destroyed?
    find_card.is_creature? and remaining_health <= 0
  end

  def damage!(n)
    self.damage += n
    save!
  end
end
