class ThisCardCanBlockTargetCard < Condition

  def evaluate(duel, stack)
    # split into smaller sub conditions?
    reach_check(duel, stack)
  end

  private

    def reach_check(duel, stack)
      !stack.target.card.has_tag?("flying") ||
          (stack.source.card.has_tag?("flying") || stack.source.card.has_tag?("reach"))
    end

end
