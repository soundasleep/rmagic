class Effect < ActiveRecord::Base
  belongs_to :card

  validates :card_id, presence: true
  validates :effect_id, presence: true
  validates :order, presence: true

  validate :valid_effect

  def valid_effect
    if !effect_type
      errors.add(:effect_id, "Could not find effect #{effect_id}")
    end
  end

  def effect_type
    @effect ||= EffectUniverse.new.find_effect(effect_id)
  end

  delegate :to_text, :modify_power, :modify_toughness, :modify_tags, to: :effect_type

end
