require 'game_helper'

RSpec.describe StartGame, type: :service do
  include CreatePremadeDecks

  let(:game_service) { CreateGame.new(game_arguments) }
  let(:game_arguments) { { user1: user1, user2: user2, deck1: deck1, deck2: deck2 } }
  let(:duel) { game_service.call }

  let(:service) { StartGame.new(arguments) }
  let(:arguments) { { duel: duel } }

  let(:system) { User.create! name: "System" }
  let(:deck1) { create_larger_premade_deck(system) }
  let(:deck2) { create_larger_premade_deck(system) }

  let(:user1) { User.create! name: "AI", is_ai: true }
  let(:user2) { User.create! name: "AI", is_ai: true }

  context "before #call" do
    context "player1" do
      let(:player) { duel.player1 }

      it "has a hand of 7 cards" do
        expect(player.hand.count).to eq(7)
      end

      it "the deck has been shuffled" do
        expect(is_shuffled?(player.deck)).to be(true)
      end
    end

    context "player2" do
      let(:player) { duel.player2 }

      it "has a hand of 7 cards" do
        expect(player.hand.count).to eq(7)
      end

      it "the deck has been shuffled" do
        expect(is_shuffled?(player.deck)).to be(true)
      end
    end

    context "the duel" do
      it "is in the mulligan phase" do
        expect(duel.phase.to_sym).to eq(:mulligan_phase)
      end
    end
  end

  context "after #call" do
    before { service.call }

    context "player1" do
      let(:player) { duel.player1 }

      it "has a hand of 7 cards" do
        expect(player.hand.count).to eq(7)
      end

      it "the deck has been shuffled" do
        expect(is_shuffled?(player.deck)).to be(true)
      end
    end

    context "player2" do
      let(:player) { duel.player2 }

      it "has a hand of 7 cards" do
        expect(player.hand.count).to eq(7)
      end

      it "the deck has been shuffled" do
        expect(is_shuffled?(player.deck)).to be(true)
      end
    end

    context "the duel" do
      it "is in the mulligan phase" do
        expect(duel.phase.to_sym).to eq(:mulligan_phase)
      end
    end
  end

  def is_shuffled?(deck)
    # a deck is shuffled if any card has an order greater than zero
    return deck.any? { |d| d.order > 0 }
  end
end
