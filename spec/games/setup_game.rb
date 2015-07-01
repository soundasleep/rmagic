require "rails_helper"

module SetupGame

  # return the created duel
  def create_game
    player1 = Player.create!(name: "Player 1", life: 20, is_ai: false)
    player2 = Player.create!(name: "Player 2", life: 20, is_ai: false)

    duel = Duel.create!(player1: player1, player2: player2)

    10.times do
      create_order_card duel.player1.deck, Library::Metaverse1.id, duel.player1.next_deck_order
      create_order_card duel.player2.deck, Library::Metaverse1.id, duel.player2.next_deck_order
    end

    3.times do
      create_card duel.player1.battlefield, Library::Forest.id
      create_card duel.player2.battlefield, Library::Forest.id
    end

    duel.save!

    duel
  end

  def create_creatures
    3.times do
      create_card duel.player1.battlefield, Library::Metaverse1.id
    end
    2.times do
      create_card duel.player2.battlefield, Library::Metaverse1.id
    end
  end

  def create_card(zone, metaverse_id)
    card = Card.create!( metaverse_id: metaverse_id, turn_played: 0 )
    zone.create! card: card
  end

  def create_order_card(zone, metaverse_id, order)
    card = Card.create!( metaverse_id: metaverse_id, turn_played: 0 )
    zone.create! card: card, order: order
  end

  def create_hand_cards(metaverse_id)
    create_card duel.player1.hand, metaverse_id
    create_card duel.player2.hand, metaverse_id
  end

  def create_battlefield_cards(metaverse_id)
    create_card duel.player1.battlefield, metaverse_id
    create_card duel.player2.battlefield, metaverse_id
  end

  def create_graveyard_cards(metaverse_id)
    create_order_card duel.player1.graveyard, metaverse_id, duel.player1.next_graveyard_order
    create_order_card duel.player2.graveyard, metaverse_id, duel.player2.next_graveyard_order
  end

  def available_attackers
    game_engine.available_attackers(duel.current_player)
  end

  def available_actions
    game_engine.available_actions(duel.player1)
  end

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
    available_actions[:ability].select { |action| action.key == index }
  end

  def available_play_actions(index)
    available_actions[:play].select { |action| action.key == index }
  end

  def game_engine
    @game_engine ||= GameEngine.new(duel)
  end

  def tap_all_lands
    # tap all battlefield lands
    duel.player1.battlefield_lands.each do |b|
      game_engine.card_action PossibleAbility.new(source: b, key: "tap")
    end
  end

  # simple helper methods
  def player1
    duel.player1
  end

  def player2
    duel.player2
  end

  def pass_until_next_turn
    t = duel.turn
    i = 0

    while duel.turn == t do
      i += 1
      assert_operator i, :<, 100, "it took too long to get to the next turn"
      game_engine.pass
    end
  end

  def pass_until_next_player
    c = duel.current_player
    i = 0

    while duel.current_player == c do
      i += 1
      assert_operator i, :<, 100, "it took too long to get to the next turn"
      game_engine.pass
    end
  end

  def pass_until_current_player_has_priority
    i = 0

    while duel.priority_player != duel.player1 do
      i += 1
      assert_operator i, :<, 100, "it took too long to get to the next priority"
      game_engine.pass
    end
  end

end

RSpec.configure do |c|
  c.include SetupGame
end

# TODO move all of these into other includes?
RSpec.shared_examples "requires mana" do
  let(:cost) { source.card.card_type.action_cost(game_engine, ability) }

  context "without mana" do
    it "is not enough mana to play" do
      expect(player1).to_not have_mana(cost)
    end

    it "is not an available ability" do
      expect(game_engine).to_not be_can_do_action(ability)
    end

    it "is not listed as an available action" do
      expect(available_abilities).to be_empty
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    it "is enough mana to play" do
      expect(player1).to be_has_mana(cost)
    end
  end
end

RSpec.shared_examples "targeted ability" do
  let(:cost) { source.card.card_type.action_cost(game_engine, targeted_ability) }

  context "the source" do
    let(:source_actions) { source.card.card_type.actions }

    it "has the action" do
      expect(source_actions).to include(ability_key)
    end
  end

  context "without mana" do
    context "with a target" do
      it "cannot be played" do
        expect(game_engine).to_not be_can_do_action(targeted_ability)
      end
    end

    context "without a target" do
      it "cannot be played" do
        expect(game_engine).to_not be_can_do_action(ability)
      end
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    context "with a target" do
      it "can be played" do
        expect(game_engine).to be_can_do_action(targeted_ability)
      end
    end

    context "without a target" do
      it "cannot be played" do
        expect(game_engine).to_not be_can_do_action(ability)
      end
    end

    context "is listed as an available action" do
      it "of one type" do
        expect(available_abilities.to_a.uniq{ |u| u.source }.length).to eq(1)
      end

      it "of two targets" do
        expect(available_abilities.length).to eq(2)
      end

      it "with the correct source and key" do
        available_actions[:play].each do |a|
          expect(a.source).to eq(source)
          expect(a.key).to eq(ability_key)
        end
      end
    end

    it "all actions have source and key and target specified" do
      available_actions[:play].each do |a|
        expect(a.source).to_not be_nil
        expect(a.key).to_not be_nil
        expect(a.target).to_not be_nil
      end
    end

    it "all actions have a description" do
      available_actions[:play].each do |a|
        expect(a.description).to_not be_nil
      end
    end
  end
end
