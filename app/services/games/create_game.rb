class CreateGame
  attr_reader :user1, :user2, :deck1, :deck2

  def initialize(user1:, user2:, deck1:, deck2:)
    @user1 = user1
    @user2 = user2
    @deck1 = deck1
    @deck2 = deck2
  end

  def call
    player1 = user1.players.create! name: user1.name, life: 20, is_ai: user1.is_ai?
    player2 = user2.players.create! name: user2.name, life: 20, is_ai: user2.is_ai?

    duel = Duel.create! player1: player1, player2: player2

    # put in premade deck order
    deck1.cards.each_with_index do |c, i|
      create_order_card player1.deck, c.metaverse_id, -i
    end
    deck2.cards.each_with_index do |c, i|
      create_order_card player2.deck, c.metaverse_id, -i
    end

    duel.save!      # TODO remove
    duel.phase.enter_phase_service.new(duel: duel).call

    duel
  end

  private

    def create_order_card(zone, metaverse_id, order)
      card = Card.create!( metaverse_id: metaverse_id, turn_played: 0 )
      zone.create! card: card, order: order
    end

end
