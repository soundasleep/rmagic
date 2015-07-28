require 'game_helper'

RSpec.describe MoveCardIntoBattlefield, type: :service do
  let(:service) { MoveCardIntoBattlefield.new(duel: duel, player: player, card: card) }
  let(:result) { service.call }

  let(:duel) { create_game }
  let(:player) { player1 }

  def cards(collection)
    collection.map(&:card)
  end

  context "a card in the battlefield" do
    let(:battlefield) { player1.battlefield.first }
    let(:card) { battlefield.card }

    it "is in the battlefield" do
      expect(cards(player1.battlefield)).to include(card)
    end

    it "is not in the graveyard" do
      expect(cards(player1.graveyard)).to_not include(card)
    end

    context "the service" do
      let(:result) { service.call }

      it "returns true" do
        expect(result).to be(true)
      end
    end

    context "after calling the service" do
      before { service.call }

      context "the card" do
        it "is in the battlefield" do
          expect(cards(player1.battlefield)).to include(card)
        end

        it "is not in the graveyard" do
          expect(cards(player1.graveyard)).to_not include(card)
        end
      end
    end
  end

  context "a card that does not exist in the duel" do
    let(:card) { Card.create! turn_played: 0, metaverse_id: Library::Forest.metaverse_id }

    it "is not the battlefield" do
      expect(cards(player1.battlefield)).to_not include(card)
    end

    it "is not in the graveyard" do
      expect(cards(player1.graveyard)).to_not include(card)
    end

    context "the service" do
      let(:result) { service.call }

      it "returns true" do
        expect(result).to be(true)
      end
    end

    context "after calling the service" do
      before { service.call }

      context "the card" do
        it "is in the battlefield" do
          expect(cards(player1.battlefield)).to include(card)
        end

        it "is not in the graveyard" do
          expect(cards(player1.graveyard)).to_not include(card)
        end
      end
    end
  end

end
