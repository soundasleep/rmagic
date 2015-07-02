class Library::Metaverse6 < CardType
  include Creature
  include CreatureAbility

  def name
    "Creature with activated abilities"
  end

  def power
    2
  end

  def toughness
    3
  end

  def mana_cost
    {
      green: 1,
      colourless: 1
    }
  end

  def destroy_cost(game_engine, hand, target = nil)
    return {
      colourless: 1
    }
  end

  # ignoring mana costs
  def can_destroy?(game_engine, hand, target = nil)
    return target != nil &&
        target.is_card? &&
        target.player.battlefield.include?(target) &&
        target.card.card_type.is_creature? &&
        can_creature_ability?(game_engine, hand)
  end

  def playing_destroy_goes_onto_stack?
    false
  end

  # an instant
  def do_destroy(game_engine, hand, target = nil)
    game_engine.destroy target

    # this card is not put into the graveyard
  end

end
