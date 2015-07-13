class TargetIsTheFirstCreatureInTheirGraveyard < Condition
  include CollectionsHelper

  def evaluate(duel, stack)
    is_first_creature?(stack.target.player.graveyard, stack.target)
  end

end
