class TargetIsTheFirstCreatureInTheirGraveyard < Condition
  include CollectionsHelper

  def evaluate(game_engine, stack)
    is_first_creature?(stack.target.player.graveyard, stack.target)
  end

end
