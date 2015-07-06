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
    Mana.new green: 1, colourless: 1
  end

  def add_life_cost(game_engine, zone_card, target = nil)
    Mana.new green: 1
  end

  class AddLifeActivatedCondition < Condition
    include CreatureAbility

    def evaluate(game_engine, stack)
      target = stack.target
      zone_card = stack.source

      return target == nil &&
        !zone_card.card.is_tapped? &&
        game_engine.duel.turn > zone_card.card.turn_played &&
        game_engine.duel.priority_player == zone_card.player &&
        game_engine.duel.phase.can_tap? &&
        zone_card.zone.cards_are_tappable? &&
        can_creature_ability?(game_engine, zone_card)
    end
  end

  def can_add_life?
    return AddLifeActivatedCondition.new

    # return TextualConditions.new([
    #   "not targeted",
    #   "this card does not have summoning sickness",
    #   "it is our turn",
    #   "this card can be tapped",
    #   "we can use card abilities",
    # ])

    # return target == nil &&
    #     !zone_card.card.is_tapped? &&
    #     game_engine.duel.turn > zone_card.card.turn_played &&
    #     game_engine.duel.priority_player == zone_card.player &&
    #     game_engine.duel.phase.can_tap? &&
    #     zone_card.zone.cards_are_tappable? &&
    #     can_creature_ability?(game_engine, zone_card)
  end

  class AddLifeActivatedAction < Action
    def execute(game_engine, stack)
      zone_card = stack.source

      # tap this card
      zone_card.card.tap_card!

      # do the action
      zone_card.player.add_life!(1)
    end
  end

  # an instant
  def do_add_life
    return AddLifeActivatedAction.new

    # return TextualActions.new([
    #   "tap this card",
    #   "add 1 life to the owner of this card",
    # ])

    # # tap this card
    # zone_card.card.tap_card!

    # # do the action
    # zone_card.player.add_life!(1)
  end

  def playing_add_life_goes_onto_stack?
    false
  end

  def self.metaverse_id
    12
  end

end
