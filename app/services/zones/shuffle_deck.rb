class ShuffleDeck
  attr_reader :duel, :player

  def initialize(duel:, player:)
    @duel = duel
    @player = player
  end

  def call
    player.deck.reload

    player.deck.each do |zone_card|
      zone_card.update! order: rand(9999)
    end

    true
  end

end
