require "game_helper"

RSpec.describe Library::AjanisSunstriker, type: :card do
  let(:duel) { create_game }
  let(:card) { player1.battlefield_creatures.first }
  let(:attacker) { available_attackers.first }
  let(:defenders) { action_finder.defendable_cards(player2) }

  before :each do
    create_card player1.battlefield, Library::AjanisSunstriker
  end

  context "our card" do
    before { duel.playing_phase! }

    it "is not tapped" do
      expect(card.card.is_tapped?).to be(false)
    end

    it "we have 20 life" do
      expect(player1.life).to eq(20)
    end

    it "is player 1's turn" do
      expect(duel.priority_player).to eq(player1)
    end

    context "in the attack phase" do
      before { duel.attacking_phase! }

      it "we have an attacker" do
        expect(attacker).to_not be_nil
      end

      it "the attacker is our card" do
        expect(attacker.card).to eq(card.card)
      end

      it "we have 20 life" do
        expect(player1.life).to eq(20)
      end

      it "is player 1's turn" do
        expect(duel.priority_player).to eq(player1)
      end

      context "and declared an attacker" do
        before { declare_attackers [attacker] }

        context "after passing priority" do
          before { pass_priority }

          it "is player 2's priority" do
            expect(duel.priority_player).to eq(player2)
          end

          it "we have no available defenders" do
            expect(defenders).to be_empty
          end

          it "we have 20 life" do
            expect(player1.life).to eq(20)
          end

          context "after passing priority" do
            before { pass_priority }

            it "is player 1's turn" do
              expect(duel.priority_player).to eq(player1)
            end

            it "we have 22 life" do
              expect(player1.life).to eq(22)
            end

            it "player 2 has 18 life" do
              expect(player2.life).to eq(18)
            end
          end

          context "when there is a creature to block" do
            before { create_card player2.battlefield, Library::AjanisSunstriker }

            it "we have one available defender" do
              expect(defenders.length).to eq(1)
            end

            it "player 1's graveyard is empty" do
              expect(player1.graveyard).to be_empty
            end

            it "player 2's graveyard is empty" do
              expect(player2.graveyard).to be_empty
            end

            let(:defender) { defenders.first }

            context "and the creature declares as a defender" do
              before { defender.declare duel }

              context "after passing priority" do
                before { pass_priority }

                it "is player 1's turn" do
                  expect(duel.priority_player).to eq(player1)
                end

                it "we have 22 life" do
                  expect(player1.life).to eq(22)
                end

                it "player 2 has 22 life" do
                  expect(player2.life).to eq(22)
                end

                it "player 1 has no creatures" do
                  expect(player1.battlefield_creatures).to be_empty
                end

                it "player 2 has no creatures" do
                  expect(player2.battlefield_creatures).to be_empty
                end

                it "player 1's graveyard is not empty" do
                  expect(player1.graveyard).to_not be_empty
                end

                it "player 2's graveyard is not empty" do
                  expect(player2.graveyard).to_not be_empty
                end
              end
            end
          end
        end
      end
    end
  end
end
