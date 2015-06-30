class Library::AddLifeActivated < CardType
  include Creature
  include CreatureAbility

  def name
    "Creature with activated add life to owner"
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

  def add_life_cost(game_engine, zone_card, target = nil)
    return {
      green: 1
    }
  end

  def can_add_life?(game_engine, zone_card, target = nil)
    return target == nil &&
        zone_card.card.can_tap? &&
        game_engine.duel.turn > zone_card.card.turn_played &&
        game_engine.duel.priority_player == zone_card.player &&
        game_engine.duel.phase.can_tap? &&
        zone_card.zone.cards_are_tappable? &&
        can_creature_ability?(game_engine, zone_card)
  end

  # an instant
  def do_add_life(game_engine, zone_card, target = nil)
    # tap this card
    zone_card.card.tap_card!

    # do the action
    zone_card.player.add_life!(1)
  end

  def self.id
    12
  end

end
