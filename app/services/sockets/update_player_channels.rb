class UpdatePlayerChannels
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    duel.players.each do |player|
      PlayerChannels.new(player).update_all
    end

    true
  end

end
