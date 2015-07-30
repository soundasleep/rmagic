class UpdateDuelChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    DuelChannels.new(duel).update_all(context)

    true
  end

  def channel_hash
    duel.id
  end

  def channel_context
    duel
  end

  private
    def context
      self
    end

end
