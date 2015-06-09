class Entity < ActiveRecord::Base
  after_initialize :init

  def init
    self.is_tapped ||= false
    self.damage ||= 0
  end

  def find_card
    CardUniverse.new.find_metaverse(metaverse_id) if metaverse_id
  end

  def find_card!
    find_card or fail "Could not find card #{metaverse_id}"
  end

  def to_text
    return find_card.to_text if find_card

    return "(metaverse #{metaverse_id})" if metaverse_id
    return "(unknown)"
  end

  def action_text(action_id)
    return find_card.action_text(action_id) if find_card

    return "(unknown action #{action_id})"
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
    find_card!.toughness - damage
  end

  def is_destroyed?
    find_card!.is_creature? and remaining_health <= 0
  end

  def damage!(n)
    self.damage += n
    save!
  end
end
