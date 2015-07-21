class PlayerPresenter
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def deck_json
    {
      deck: player.deck.map { |g| ZoneCardPresenter.new(g) }.map(&:to_safe_json)
    }
  end

  def battlefield_json
    {
      battlefield: player.battlefield.map { |g| ZoneCardPresenter.new(g) }.map(&:to_safe_json)
    }
  end

  def hand_json
    {
      hand: player.hand.map { |g| ZoneCardPresenter.new(g) }.map(&:to_safe_json)
    }
  end

  def graveyard_json
    {
      graveyard: player.graveyard.map { |g| ZoneCardPresenter.new(g) }.map(&:to_safe_json)
    }
  end

end
