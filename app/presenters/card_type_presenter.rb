class CardTypePresenter
  attr_reader :card_type

  def initialize(card_type)
    @card_type = card_type
  end

  def to_json
    {
      name: card_type.name,
      metaverse_id: card_type.metaverse_id,
      mana_cost: card_type.cost_string,
      is_creature: card_type.is_creature?,
      is_land: card_type.is_land?,
      is_spell: card_type.is_spell?,
      is_instant: card_type.is_instant?,
      is_enchantment: card_type.is_enchantment?,
      actions: card_type.actions
    }
  end

end
