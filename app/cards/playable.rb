module Playable

  def play_cost(game_engine, hand, target = nil)
    mana_cost
  end

  class PlayCondition < Condition
    def evaluate(game_engine, stack)
      target = stack.target
      hand = stack.source

      # TODO move these into testable, composable conditions
      return target == nil &&
          game_engine.duel.priority_player == hand.player &&
          game_engine.duel.current_player == hand.player &&
          game_engine.duel.phase.can_play? &&
          hand.zone.can_play_from?
    end
  end

  # ignoring mana costs
  def can_play?
    return PlayCondition.new
  end

  class PlayAction < Action
    def execute(game_engine, stack)
      # TODO maybe each of these resolve actions can be moved into services
      # put it into the battlefield
      game_engine.move_into_battlefield stack.player, stack

      # save the turn it was played
      stack.card.update! turn_played: game_engine.duel.turn
    end
  end

  # ability mana cost has already been consumed
  def resolve_play
    PlayAction.new
  end

  def playing_play_goes_onto_stack?
    true
  end

end
