class UpdateActionLogChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.update_action_log_channels "UpdateActionLogChannels"

    true
  end

end
