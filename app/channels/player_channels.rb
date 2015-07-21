class PlayerChannels < Channels
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def channels
    ["deck", "battlefield", "hand", "graveyard"]
  end

  def channel_id
    player.id
  end

  def presenter
    PlayerPresenter.new(player)
  end

end
