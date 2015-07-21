class UpdateAllChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.reload

    UpdateDuelChannels.new(duel: duel).call
    duel.players.each do |player|
      UpdatePlayerChannels.new(player: player).call
    end

    true
  end

end
