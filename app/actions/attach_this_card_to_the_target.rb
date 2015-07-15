class AttachThisCardToTheTarget < Action

  def execute(duel, stack)
    if !stack.battlefield_targets.any?
      fail "No battlefield target defined for #{stack}: #{stack.to_json} (#{stack.battlefield_targets.to_a})"
    end

    # add an effect
    player = stack.player
    card = stack.source
    target = stack.battlefield_targets.first.target

    AttachCardToTarget.new(duel: duel, player: player, card: card, target: target).call
  end

end
