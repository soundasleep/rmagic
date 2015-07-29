class RequestPass
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    # add a log
    duel.action_logs.create! duel: duel, global_action: "request_pass"

    if duel.priority_player.last_action <= Time.now - 10.seconds
      # force a pass
      PassPriority.new(duel: duel).call
    end

    true
  end

end
