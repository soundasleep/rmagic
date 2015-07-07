module Land

  def is_land?
    true
  end

  def play_cost(game_engine, hand, target = nil)
    mana_cost
  end

  # TODO implement with conditions
  class LandPlayCondition < Condition
    def evaluate(game_engine, stack)
      target = stack.target
      hand = stack.source

      return target == nil &&
          game_engine.duel.priority_player == hand.player &&
          game_engine.duel.current_player == hand.player &&
          game_engine.duel.phase.can_play? &&
          hand.zone.can_play_from? &&
          !has_played_a_land?(hand.player, game_engine.duel.turn)
    end

    def has_played_a_land?(player, turn)
      (player.battlefield + player.graveyard).any?{ |card| card.card.turn_played == turn }
    end
  end

  # ignoring mana costs
  def can_play?
    return LandPlayCondition.new
  end

  # 305.1  Playing a land is a special action; it doesn’t use the stack (see rule 115)
  def playing_play_goes_onto_stack?
    false
  end

  # TODO implement with actions
  class LandPlayAction < Action
    def execute(game_engine, stack)
      target = stack.target
      hand = stack.source

      # put it into the battlefield
      game_engine.move_into_battlefield hand.player, hand

      # save the turn it was played
      hand.card.update! turn_played: game_engine.duel.turn
    end
  end

  # ability mana cost has already been consumed
  def do_play
    return LandPlayAction.new
  end

  class LandTapCondition < Condition
    def evaluate(game_engine, stack)
      target = stack.target
      battlefield = stack.source

      return target == nil &&
          game_engine.duel.priority_player == battlefield.player &&
          game_engine.duel.phase.can_tap? &&
          !battlefield.card.is_tapped? &&
          battlefield.zone.cards_are_tappable?
    end
  end

  def can_tap?
    return LandTapCondition.new
  end

  def playing_tap_goes_onto_stack?
    false
  end

  class LandUntapCondition < Condition
    def evaluate(game_engine, stack)
      target = stack.target
      battlefield = stack.source

      return target == nil &&
          false # we can never manually untap lands
    end
  end

  def can_untap?
    return LandUntapCondition.new
  end

  def playing_untap_goes_onto_stack?
    false
  end

  def tap_cost(game_engine, battlefield, target = nil)
    Mana.new
  end

  def untap_cost(game_engine, battlefield, target = nil)
    Mana.new
  end

  class LandTapAction < Action
    def execute(game_engine, stack)
      target = stack.target
      battlefield = stack.source
      card_type = stack.source.card.card_type

      fail "Cannot tap #{battlefield.card}: already tapped" if battlefield.card.is_tapped?

      battlefield.card.tap_card!
      battlefield.player.add_mana! card_type.mana_provided
    end
  end

  def do_tap
    return LandTapAction.new
  end

  class LandUntapAction < Action
    def execute(game_engine, stack)
      target = stack.target
      battlefield = stack.source

      fail "Cannot untap #{battlefield.card}: already untapped" if !battlefield.card.is_tapped?

      battlefield.card.untap_card!
    end
  end

  def do_untap
    return LandUntapAction.new
  end

end
