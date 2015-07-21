class GameAction
  attr_reader :player, :key

  def initialize(player:, key:)
    @player = player
    @key = key
  end

  def do(duel)
    DoGameAction.new(duel: duel, player: player, key: key).call
  end

  def description
    "#{key.camelcase}"
  end

end
