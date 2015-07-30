require "game_helper"

RSpec.describe "Requesting passes", type: :game do
  let(:duel) { create_game }
  let(:logs) { duel.action_logs.select{ |log| log.global_action == "request_pass" } }

  # make sure we have the duel created *before* we time travel
  before { duel.save! }

  context "the game" do
    it "is player 1's priority" do
      expect(duel.priority_player).to eq(player1)
    end

    context "after 1 second" do
      let(:diff) { 1.seconds }

      before { Timecop.freeze(Time.now + diff) }
      after { Timecop.return }

      it "it is player 1's priority" do
        expect(duel.priority_player).to eq(player1)
      end

      it "there are no request pass logs" do
        expect(logs).to be_empty
      end

      context "after a pass is requested" do
        before { RequestPass.new(duel: duel).call }

        it "it is player 1's priority" do
          expect(duel.priority_player).to eq(player1)
        end

        it "there is one request pass log" do
          expect(logs.length).to eq(1)
        end
      end
    end

    context "after 1 minute" do
      let(:diff) { 1.minutes }

      before { Timecop.freeze(Time.now + diff) }
      after { Timecop.return }

      it "it is player 1's priority" do
        expect(duel.priority_player).to eq(player1)
      end

      context "after a pass is requested" do
        before { RequestPass.new(duel: duel).call }

        it "it is player 2's priority" do
          expect(duel.priority_player).to eq(player2)
        end

        it "there is one request pass log" do
          expect(logs.length).to eq(1)
        end

        context "after a pass is immediately requested" do
          before { RequestPass.new(duel: duel).call }

          it "it is player 2's priority" do
            expect(duel.priority_player).to eq(player2)
          end

          it "there is two request pass logs" do
            expect(logs.length).to eq(2)
          end
        end
      end

      context "after player 1 does something" do
        let(:card) { player1.battlefield.select{ |c| c.card.card_type.is_land? }.first }
        let(:action) { AbilityAction.new(source: card, key: "tap") }

        before { DoAction.new(duel: duel, action: action).call }

        it "it is player 1's priority" do
          expect(duel.priority_player).to eq(player1)
        end

        context "after a pass is immediately requested" do
          before { RequestPass.new(duel: duel).call }

          it "it is player 1's priority" do
            expect(duel.priority_player).to eq(player1)
          end
        end

        context "after 1 second" do
          let(:diff2) { 1.second }

          before { Timecop.freeze(Time.now + diff2) }
          after { Timecop.return }

          it "it is player 1's priority" do
            expect(duel.priority_player).to eq(player1)
          end

          context "after a pass is requested" do
            before { RequestPass.new(duel: duel).call }

            it "it is player 1's priority" do
              expect(duel.priority_player).to eq(player1)
            end
          end
        end

        context "after 1 minute" do
          let(:diff2) { 1.minute }

          before { Timecop.freeze(Time.now + diff2) }
          after { Timecop.return }

          it "it is player 1's priority" do
            expect(duel.priority_player).to eq(player1)
          end

          context "after a pass is requested" do
            before { RequestPass.new(duel: duel).call }

            it "it is player 2's priority" do
              expect(duel.priority_player).to eq(player2)
            end
          end
        end

      end
    end

  end

end
