require "game_helper"

RSpec.describe "Drawing", type: :game do
  let(:duel) { create_game }

  it "starts in drawing phase" do
    expect(duel.drawing_phase?).to be(true)
  end

  it "player 1 is the first player" do
    expect(duel.first_player).to eq(duel.player1)
  end

  context "turn 1" do
    it "we are turn 1" do
      expect(duel.turn).to eq(1)
    end

    it "player 1 has an empty hand" do
      expect(player1.hand).to be_empty
    end

    it "player 2 has an empty hand" do
      expect(player1.hand).to be_empty
    end

    context "in cleanup phase" do
      before :each do
        duel.cleanup_phase!
        duel.update! ({ current_player_number: 2, priority_player_number: 2 })
      end

      context "after passing priority" do
        before { pass_priority }

        it "player 1 has an empty hand" do
          expect(player1.hand).to be_empty
        end

        it "player 2 has an empty hand" do
          expect(player2.hand).to be_empty
        end

        context "after passing priority" do
          before { pass_priority }

          it "player 1 has a card" do
            expect(player1.hand.length).to eq(1)
          end

          it "player 2 has an empty hand" do
            expect(player2.hand).to be_empty
          end
        end
      end
    end

    context "in cleanup phase of the other player" do
      before :each do
        duel.cleanup_phase!
        duel.update! ({ current_player_number: 1, priority_player_number: 1 })
      end

      context "after passing priority" do
        before { pass_priority }

        it "player 1 has an empty hand" do
          expect(player1.hand).to be_empty
        end

        it "player 2 has an empty hand" do
          expect(player2.hand).to be_empty
        end

        context "after passing priority" do
          before { pass_priority }

          it "player 1 has an empty hand" do
            expect(player1.hand).to be_empty
          end

          it "player 2 has a card" do
            expect(player2.hand.length).to eq(1)
          end
        end
      end
    end
  end

end
