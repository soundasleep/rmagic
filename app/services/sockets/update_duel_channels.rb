class UpdateDuelChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.trigger_channel_update

    true
  end

end