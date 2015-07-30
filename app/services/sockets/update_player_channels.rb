class UpdatePlayerChannels
  attr_reader :player

  def initialize(player:)
    @player = player
  end

  def call
    PlayerChannels.new(player).update_all(context)

    true
  end

  def channel_hash
    player.id
  end

  def channel_context
    player
  end

  private
    def context
      self
    end

end
