require 'game_helper'

RSpec.describe DeclareMulligans, type: :service do
  include CreatePremadeDecks

  let(:game_service) { CreateGame.new(game_arguments) }
  let(:game_arguments) { { user1: user1, user2: user2, deck1: deck1, deck2: deck2 } }
  let(:duel) { game_service.call }

  let(:start_service) { StartGame.new(start_arguments) }
  let(:start_arguments) { { duel: duel } }
  before { start_service.call }

  let(:service) { DeclareMulligans }

  let(:system) { User.create! name: "System" }
  let(:deck1) { create_larger_premade_deck(system) }
  let(:deck2) { create_larger_premade_deck(system) }

  let(:user1) { User.create! name: "AI", is_ai: true }
  let(:user2) { User.create! name: "AI", is_ai: true }

  context "the duel" do
    it "starts in the mulligan phase" do
      expect(duel.phase.to_sym).to eq(:mulligan_phase)
    end
  end

  context "with no mulligans" do
    let(:arguments) { { duel: duel, mulligan1: false, mulligan2: false } }

    before { service.new(arguments).call }

    context "player1" do
      let(:player) { duel.player1 }

      it "has a hand of 7 cards" do
        expect(player.hand.count).to eq(7)
      end

      it "has declared 0 mulligans" do
        expect(player.mulligans).to eq(0)
      end
    end

    context "player2" do
      let(:player) { duel.player2 }

      it "has a hand of 7 cards" do
        expect(player.hand.count).to eq(7)
      end

      it "has declared 0 mulligans" do
        expect(player.mulligans).to eq(0)
      end
    end

    context "the duel" do
      it "is in the drawing phase" do
        expect(duel.phase.to_sym).to eq(:drawing_phase)
      end
    end
  end

  context "with only the first player mulliganing" do
    let(:arguments) { { duel: duel, mulligan1: true, mulligan2: false } }

    before { service.new(arguments).call }

    context "player1" do
      let(:player) { duel.player1 }

      it "has a hand of 6 cards" do
        expect(player.hand.count).to eq(6)
      end

      it "has declared 1 mulligans" do
        expect(player.mulligans).to eq(1)
      end
    end

    context "player2" do
      let(:player) { duel.player2 }

      it "has a hand of 7 cards" do
        expect(player.hand.count).to eq(7)
      end

      it "has declared 0 mulligans" do
        expect(player.mulligans).to eq(0)
      end
    end

    context "the duel" do
      it "is in the mulligan phase" do
        expect(duel.phase.to_sym).to eq(:mulligan_phase)
      end
    end

    context "and then with no mulligans" do
      let(:no_arguments) { { duel: duel, mulligan1: false, mulligan2: false } }

      before { service.new(no_arguments).call }

      context "player1" do
        let(:player) { duel.player1 }

        it "has a hand of 6 cards" do
          expect(player.hand.count).to eq(6)
        end

        it "has declared 1 mulligans" do
          expect(player.mulligans).to eq(1)
        end
      end

      context "player2" do
        let(:player) { duel.player2 }

        it "has a hand of 7 cards" do
          expect(player.hand.count).to eq(7)
        end

        it "has declared 0 mulligans" do
          expect(player.mulligans).to eq(0)
        end
      end

      context "the duel" do
        it "is in the drawing phase" do
          expect(duel.phase.to_sym).to eq(:drawing_phase)
        end
      end
    end

    context "and then with the second player mulliganing" do
      let(:arguments2) { { duel: duel, mulligan1: false, mulligan2: true } }

      before { service.new(arguments2).call }

      context "player1" do
        let(:player) { duel.player1 }

        it "has a hand of 6 cards" do
          expect(player.hand.count).to eq(6)
        end

        it "has declared 1 mulligans" do
          expect(player.mulligans).to eq(1)
        end
      end

      context "player2" do
        let(:player) { duel.player2 }

        it "has a hand of 6 cards" do
          expect(player.hand.count).to eq(6)
        end

        it "has declared 1 mulligans" do
          expect(player.mulligans).to eq(1)
        end
      end

      context "the duel" do
        it "is in the mulligan phase" do
          expect(duel.phase.to_sym).to eq(:mulligan_phase)
        end
      end

      context "and then with no mulligans" do
        let(:no_arguments) { { duel: duel, mulligan1: false, mulligan2: false } }

        before { service.new(no_arguments).call }

        context "player1" do
          let(:player) { duel.player1 }

          it "has a hand of 6 cards" do
            expect(player.hand.count).to eq(6)
          end
        end

        context "player2" do
          let(:player) { duel.player2 }

          it "has a hand of 6 cards" do
            expect(player.hand.count).to eq(6)
          end
        end

        context "the duel" do
          it "is in the drawing phase" do
            expect(duel.phase.to_sym).to eq(:drawing_phase)
          end
        end
      end
    end
  end

  context "with both players mulliganing" do
    let(:arguments) { { duel: duel, mulligan1: true, mulligan2: true } }

    before { service.new(arguments).call }

    context "player1" do
      let(:player) { duel.player1 }

      it "has a hand of 6 cards" do
        expect(player.hand.count).to eq(6)
      end
    end

    context "player2" do
      let(:player) { duel.player2 }

      it "has a hand of 6 cards" do
        expect(player.hand.count).to eq(6)
      end
    end

    context "the duel" do
      it "is in the mulligan phase" do
        expect(duel.phase.to_sym).to eq(:mulligan_phase)
      end
    end
  end

end
