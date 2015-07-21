class DuelChannels < Channels
  attr_reader :duel

  def initialize(duel)
    @duel = duel
  end

  def channels
    ["duel", "action_logs"]
  end

  def channel_id
    duel.id
  end

  def presenter
    DuelPresenter.new(duel)
  end

end
