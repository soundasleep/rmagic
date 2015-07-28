require "game_helper"

RSpec.describe "Flyers can defend normal creatures", type: :game do
  let(:duel) { create_game }
  let(:attacker) { available_attackers.first }
  let(:defenders) { action_finder.defendable_cards(player2) }

  before :each do
    create_card player1.battlefield, Library::BasicCreature
  end

  it "player 2 has 20 life" do
    expect(player2.life).to eq(20)
  end

  context "in attacking phase" do
    before { duel.attacking_phase! }

    context "a flyer" do
      let(:flyer) { duel.player1.battlefield_creatures.first }

      it "can attack" do
        expect(available_attackers).to include(flyer)
      end

      context "is declared as an attacker" do
        before { declare_attackers [attacker] }

        context "after passing priority" do
          before { pass_priority }

          it "we have no available defenders" do
            expect(defenders).to be_empty
          end
        end

        context "if player 2 has a flyer" do
          before { create_card player2.battlefield, Library::SuntailHawk }

          it "player 2 has a creature" do
            expect(player2.battlefield_creatures).to_not be_empty
          end

          context "after passing priority" do
            before { pass_priority }

            it "we have one available defender" do
              expect(defenders.length).to eq(1)
            end

            context "declaring it as a defender" do
              before { defenders.first.declare(duel) }

              context "after passing priority" do
                before { pass_priority }

                it "player 1 has one creature" do
                  expect(player1.battlefield_creatures.length).to eq(1)
                end

                it "player 2 has no creatures" do
                  expect(player2.battlefield_creatures).to be_empty
                end

                it "player 1 has no creatures in the graveyard" do
                  expect(player1.graveyard_creatures).to be_empty
                end

                it "player 2 has a creature in the graveyard" do
                  expect(player2.graveyard_creatures.length).to eq(1)
                end

                it "player 2 has 20 life" do
                  expect(player2.life).to eq(20)
                end
              end
            end
          end
        end
      end
    end
  end

end
