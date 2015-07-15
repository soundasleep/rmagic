require "game_helper"

RSpec.describe "Mulligan actions spec", type: :game do
  let(:duel) { create_game }

  before {
    duel.update! turn: 0

    # create lots more cards so we can draw without ending the game
    duel.players.each do |player|
      10.times { create_order_card player.deck, Library::Forest, 1 }
    end

    duel.mulligan_phase!
    duel.enter_phase!
  }

  it "starts in mulligan phase" do
    expect(duel.mulligan_phase?).to be(true)
  end

  it "player 1 has 7 cards" do
    expect(player1.hand.length).to eq(7)
  end

  it "player 2 has 7 cards" do
    expect(player2.hand.length).to eq(7)
  end

  it "is player 1's turn" do
    expect(duel.priority_player).to eq(player1)
  end

  it "we are in turn 0" do
    expect(duel.turn).to eq(0)
  end

  context "with no mulligans" do
    context "player 1 passes" do
      before { pass_priority }

      it "is now in mulligan phase" do
        expect(duel.phase.to_sym).to eq(:mulligan_phase)
      end

      it "is player 2's turn" do
        expect(duel.priority_player).to eq(player2)
      end

      it "we are in turn 0" do
        expect(duel.turn).to eq(0)
      end

      context "player 2 passes" do
        before { pass_priority }

        it "is player 1's turn" do
          expect(duel.priority_player).to eq(player1)
        end

        it "is now in drawing phase" do
          expect(duel.phase.to_sym).to eq(:drawing_phase)
        end

        it "player 1 has 7 cards" do
          expect(player1.hand.length).to eq(7)
        end

        it "player 2 has 7 cards" do
          expect(player2.hand.length).to eq(7)
        end

        it "we are in turn 1" do
          expect(duel.turn).to eq(1)
        end
      end
    end
  end

  context "with player 1 declaring mulligans" do
    it "player 1 has game options" do
      expect(game_actions(player1)).to_not be_empty
    end

    it "player 1 has a mulligan option" do
      expect(game_actions(player1).any? { |a| a.key == "mulligan" }).to be(true)
    end

    it "player 2 does not have a mulligan option" do
      expect(game_actions(player2).any? { |a| a.key == "mulligan" }).to be(false)
    end

    context "player 1 declares mulligan" do
      let(:action) { game_actions(player1).select{ |a| a.key == "mulligan" }.first }

      before { action.do(duel) }

      it "is now in mulligan phase" do
        expect(duel.phase.to_sym).to eq(:mulligan_phase)
      end

      it "is player 2's turn" do
        expect(duel.priority_player).to eq(player2)
      end

      it "we are in turn 0" do
        expect(duel.turn).to eq(0)
      end

      context "player 2 passes" do
        before { pass_priority }

        it "is player 1's turn" do
          expect(duel.priority_player).to eq(player1)
        end

        it "is still in mulligan phase" do
          expect(duel.phase.to_sym).to eq(:mulligan_phase)
        end

        it "player 1 has 6 cards" do
          expect(player1.hand.length).to eq(6)
        end

        it "player 2 has 7 cards" do
          expect(player2.hand.length).to eq(7)
        end

        it "we are in turn 0" do
          expect(duel.turn).to eq(0)
        end

        context "with no mulligans" do
          context "player 1 passes" do
            before { pass_priority }

            it "is now in mulligan phase" do
              expect(duel.phase.to_sym).to eq(:mulligan_phase)
            end

            it "is player 2's turn" do
              expect(duel.priority_player).to eq(player2)
            end

            it "we are in turn 0" do
              expect(duel.turn).to eq(0)
            end

            context "player 2 passes" do
              before { pass_priority }

              it "is player 1's turn" do
                expect(duel.priority_player).to eq(player1)
              end

              it "is now in drawing phase" do
                expect(duel.phase.to_sym).to eq(:drawing_phase)
              end

              it "player 1 has 7 cards" do
                expect(player1.hand.length).to eq(6)
              end

              it "player 2 has 7 cards" do
                expect(player2.hand.length).to eq(7)
              end

              it "we are in turn 1" do
                expect(duel.turn).to eq(1)
              end
            end
          end
        end
      end
    end
  end

end
