class DrawXCards < ParameterisedAction

  def execute(duel, stack)
    x.times do
      DrawCard.new(duel: duel, player: stack.player).call
    end
  end

end
