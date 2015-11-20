# maybe split this up into a number of smaller helpers
# e.g. GameHelper, CardHelper, TurnHelper, CardCreationHelper
module GameHelper

  # return the created duel
  def create_game
    player1 = Player.create!(name: "Player 1", life: 20, is_ai: false)
    player2 = Player.create!(name: "Player 2", life: 20, is_ai: false)

    duel = Duel.create!(player1: player1, player2: player2)

    2.times do
      create_order_card duel.player1.deck, Library::BasicCreature, duel.player1.next_deck_order
      create_order_card duel.player2.deck, Library::BasicCreature, duel.player2.next_deck_order
    end

    3.times do
      create_card duel.player1.battlefield, Library::Forest
      create_card duel.player2.battlefield, Library::Forest
    end

    duel.drawing_phase!

    duel
  end

  def create_creatures
    3.times do
      create_card duel.player1.battlefield, Library::BasicCreature
    end
    2.times do
      create_card duel.player2.battlefield, Library::BasicCreature
    end
  end

  def create_card(zone, card_type)
    card = Card.create!( metaverse_id: card_type.metaverse_id, turn_played: 0 )
    zone.create! card: card
  end

  def create_order_card(zone, card_type, order)
    card = Card.create!( metaverse_id: card_type.metaverse_id, turn_played: 0 )
    zone.create! card: card, order: order
  end

  def create_hand_cards(card_type)
    create_card duel.player1.hand, card_type
    create_card duel.player2.hand, card_type
  end

  def create_battlefield_cards(card_type)
    create_card duel.player1.battlefield, card_type
    create_card duel.player2.battlefield, card_type
  end

  def create_graveyard_cards(card_type)
    create_order_card duel.player1.graveyard, card_type, duel.player1.next_graveyard_order
    create_order_card duel.player2.graveyard, card_type, duel.player2.next_graveyard_order
  end

  def create_deck_cards(card_type)
    create_order_card duel.player1.deck, card_type, duel.player1.next_deck_order
    create_order_card duel.player2.deck, card_type, duel.player2.next_deck_order
  end

  def available_attackers
    action_finder.available_attackers(duel.current_player)
  end

  delegate :playable_cards, :ability_cards, :defendable_cards, :game_actions, to: :action_finder
  delegate :player1, :player2, to: :duel

  def actions(card, action)
    duel.action_logs.where card_action: action, card: card
  end

  def declaring_actions(hand)
    actions(hand.card, "declare")
  end

  def defending_actions(hand)
    actions(hand.card, "defend")
  end

  def defended_actions(hand)
    actions(hand.card, "defended")
  end

  def attacking_actions(hand)
    actions(hand.card, "attack")
  end

  def graveyard_actions(card)
    actions(card, "graveyard")
  end

  def available_ability_actions(index)
    ability_cards(player1).select { |action| action.key == index }
  end

  def available_play_actions(index)
    playable_cards(player1).select { |action| action.key == index }
  end

  def declare_attackers(zone_cards)
    DeclareAttackers.new(duel: duel, zone_cards: zone_cards).call
  end

  def tap_all_lands
    # check we have lands to tap
    # if this fails, the test probably can be cleaned up
    expect(duel.priority_player.battlefield_lands.select { |b| !b.card.is_tapped? }).to_not be_empty, "Player #{duel.priority_player.name} had no untapped lands"

    # tap all battlefield lands
    duel.priority_player.battlefield_lands.each do |b|
      AbilityAction.new(source: b, key: "tap").do(duel)
    end
  end

  def pass_until_next_turn
    t = duel.turn
    i = 0

    while duel.turn == t do
      i += 1
      raise "it took too long to get to the next turn" if i > 100
      pass_priority
    end
  end

  def pass_until_next_player
    c = duel.current_player
    i = 0

    while duel.current_player == c do
      i += 1
      raise "it took too long to get to the next player" if i > 100
      pass_priority
    end
  end

  def pass_until_current_player_has_priority
    i = 0

    while duel.priority_player != player1 do
      i += 1
      raise "it took too long to get to the next priority" if i > 100
      pass_priority
    end
  end

  def pass_until_next_phase
    c = duel.phase
    i = 0

    while duel.phase == c do
      i += 1
      raise "it took too long to get to the next phase" if i > 100
      pass_priority
    end
  end

  def pass_until_stack_resolves
    i = 0

    while !duel.stack.empty? do
      i += 1
      raise "it took too long to resolve the stack" if i > 100
      pass_priority
    end
  end

  def pass_priority
    PassPriority.new(duel: duel).call
  end

  def action_finder
    @action_finder ||= ActionFinder.new(duel)
  end

  # helper method to print out action log
  def print_log
    duel.action_logs.each do |log|
      puts "- #{log.player.name} #{log.action_text}"
    end
  end
end

module CreatePremadeDecks
  def create_premade_deck(user)
    deck = user.premade_decks.create! name: "Test Deck"

    deck.cards.create! metaverse_id: Library::Forest.metaverse_id
    deck.cards.create! metaverse_id: Library::Island.metaverse_id

    deck
  end

  def create_larger_premade_deck(user)
    deck = user.premade_decks.create! name: "Larger Test Deck"

    10.times { deck.cards.create! metaverse_id: Library::Forest.metaverse_id }
    10.times { deck.cards.create! metaverse_id: Library::Island.metaverse_id }

    deck
  end
end
