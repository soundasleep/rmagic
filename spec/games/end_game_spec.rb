require "game_helper"

RSpec.describe "Ending games", type: :game do
  let(:duel) { create_game }
  let(:game_actions) { action_finder.game_actions(player) }
  let(:won_logs) { duel.action_logs.where(global_action: "won") }
  let(:lost_logs) { duel.action_logs.where(global_action: "lost") }

  context "the game" do
    it "is not finished yet" do
      expect(duel.is_finished?).to be(false)
    end

    it "is not in the finished phase" do
      expect(duel.finished_phase?).to be(false)
    end

    it "has nil winners" do
      expect(duel.winners).to be_nil
    end

    it "has nil losers" do
      expect(duel.losers).to be_nil
    end

    it "has nil drawers" do
      expect(duel.drawers).to be_nil
    end

    it "player 1 has less than 5 cards in their deck" do
      expect(player1.deck.length).to be <= 5
    end

    it "player 2 has less than 5 cards in their deck" do
      expect(player2.deck.length).to be <= 5
    end

    it "has no won logs" do
      expect(won_logs).to be_empty
    end

    it "has no lost logs" do
      expect(lost_logs).to be_empty
    end
  end

  context "player 1" do
    let(:player) { player1 }

    it "has a pass action" do
      expect(game_actions.map(&:key)).to include("pass")
    end
  end

  context "player 2" do
    let(:player) { player2 }

    it "does not have a pass action" do
      expect(game_actions.map(&:key)).to_not include("pass")
    end
  end

  # 104.3c If a player is required to draw more cards than are left in
  # his or her library, he or she draws the remaining cards, and then loses
  # the game the next time a player would receive priority.
  context "when the first player draws five cards" do
    before :each do
      5.times { DrawCard.new(duel: duel, player: player1).call }
    end

    it "player 1 has an empty deck" do
      expect(player1.deck).to be_empty
    end

    context "the game" do
      it "is not finished yet" do
        expect(duel.is_finished?).to be(false)
      end

      it "has nil winners" do
        expect(duel.winners).to be_nil
      end

      it "has nil losers" do
        expect(duel.losers).to be_nil
      end

      it "has nil drawers" do
        expect(duel.drawers).to be_nil
      end
    end

    context "after passing" do
      before { pass_priority }

      context "the game" do
        it "is finished" do
          expect(duel.is_finished?).to be(true)
        end

        it "is in the finished phase" do
          expect(duel.finished_phase?).to be(true)
        end

        it "has one winner" do
          expect(duel.winners).to eq([player2])
        end

        it "has one loser" do
          expect(duel.losers).to eq([player1])
        end

        it "has no drawers" do
          expect(duel.drawers).to be_empty
        end

        it "has one won logs" do
          expect(won_logs.length).to eq(1)
        end

        it "has one won log for player 2" do
          expect(won_logs.first.player).to eq(player2)
        end

        it "has one lost logs" do
          expect(lost_logs.length).to eq(1)
        end

        it "has one lost log for player 1" do
          expect(lost_logs.first.player).to eq(player1)
        end

      end

      context "player 1" do
        let(:player) { player1 }

        it "has no available game actions" do
          expect(game_actions).to be_empty
        end
      end

      context "player 2" do
        let(:player) { player2 }

        it "has no available game actions" do
          expect(game_actions).to be_empty
        end
      end
    end

    # 104.4a If all the players remaining in a game lose simultaneously,
    # the game is a draw.
    context "when the second player also draws five cards" do
      before :each do
        5.times { DrawCard.new(duel: duel, player: player2).call }
      end

      it "player 2 has an empty deck" do
        expect(player2.deck).to be_empty
      end

      context "the game" do
        it "is not finished yet" do
          expect(duel.is_finished?).to be(false)
        end

        it "has nil winners" do
          expect(duel.winners).to be_nil
        end

        it "has nil losers" do
          expect(duel.losers).to be_nil
        end

        it "has nil drawers" do
          expect(duel.drawers).to be_nil
        end
      end

      context "after passing" do
        before { pass_priority }

        context "the game" do
          it "is finished" do
            expect(duel.is_finished?).to be(true)
          end

          it "is in the finished phase" do
            expect(duel.finished_phase?).to be(true)
          end

          it "has no winners" do
            expect(duel.winners).to be_empty
          end

          it "has no losers" do
            expect(duel.losers).to be_empty
          end

          it "has two drawers" do
            expect(duel.drawers).to eq([player1, player2])
          end

          it "has no won logs" do
            expect(won_logs).to be_empty
          end

          it "has two lost logs" do
            expect(lost_logs.length).to eq(2)
          end

          it "has a lost log for player 2" do
            expect(lost_logs.map(&:player)).to include(player2)
          end

          it "has a lost log for player 1" do
            expect(lost_logs.map(&:player)).to include(player1)
          end
        end
      end
    end
  end

  # If a player’s life total is 0 or less, he or she loses the game the next
  # time a player would receive priority. (This is a state-based action. See rule 704.)
  context "when the first player has zero life" do
    before { player1.update! life: 0 }

    context "the game" do
      it "is not finished yet" do
        expect(duel.is_finished?).to be(false)
      end

      it "has nil winners" do
        expect(duel.winners).to be_nil
      end

      it "has nil losers" do
        expect(duel.losers).to be_nil
      end

      it "has nil drawers" do
        expect(duel.drawers).to be_nil
      end
    end

    context "after passing" do
      before { pass_priority }

      context "the game" do
        it "is finished" do
          expect(duel.is_finished?).to be(true)
        end

        it "is in the finished phase" do
          expect(duel.finished_phase?).to be(true)
        end

        it "has one winner" do
          expect(duel.winners).to eq([player2])
        end

        it "has one loser" do
          expect(duel.losers).to eq([player1])
        end

        it "has no drawers" do
          expect(duel.drawers).to be_empty
        end
      end

      context "player 1" do
        let(:player) { player1 }

        it "has no available game actions" do
          expect(game_actions).to be_empty
        end
      end

      context "player 2" do
        let(:player) { player2 }

        it "has no available game actions" do
          expect(game_actions).to be_empty
        end
      end
    end
  end

  # If a player’s life total is 0 or less, he or she loses the game the next
  # time a player would receive priority. (This is a state-based action. See rule 704.)
  context "when the first player has negative life" do
    before { player1.update! life: -100 }

    context "the game" do
      it "is not finished yet" do
        expect(duel.is_finished?).to be(false)
      end
    end

    context "after passing" do
      before { pass_priority }

      context "the game" do
        it "is finished" do
          expect(duel.is_finished?).to be(true)
        end

        it "has one winner" do
          expect(duel.winners).to eq([player2])
        end

        it "has one loser" do
          expect(duel.losers).to eq([player1])
        end

        it "has no drawers" do
          expect(duel.drawers).to be_empty
        end
      end
    end
  end

end
