class PlayerChannels < Channels
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def channels
    ["player", "deck", "battlefield", "hand", "graveyard", "actions"]
  end

  def private_channels
    ["deck", "battlefield", "hand", "graveyard", "actions"]
  end

  def channel_id
    player.id
  end

  def channel_hash
    player.id     # TODO use a secure hash function instead
  end

  def presenter
    PlayerPresenter.new(player)
  end

end
