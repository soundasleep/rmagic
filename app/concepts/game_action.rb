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

  def safe_json
    {
      key: key,
      player_id: player.id,
      description: description
    }
  end

end
