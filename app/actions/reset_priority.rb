class ResetPriority < Action

  def execute(duel, action)
    # TODO make this into a service
    duel.reset_priority!
  end

end
