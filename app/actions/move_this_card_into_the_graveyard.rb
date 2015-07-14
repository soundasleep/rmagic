# TODO rename this MoveThisCardOntoTheGraveyard
class MoveThisCardIntoTheGraveyard < Action

  def execute(duel, stack)
    player = stack.player
    card = stack.source.card

    MoveCardOntoGraveyard.new(duel: duel, player: player, card: card).call
  end

end
