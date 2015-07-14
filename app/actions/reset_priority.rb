class ResetPriority < Action

  def execute(duel, action)
    duel.reset_priority!
  end

end
