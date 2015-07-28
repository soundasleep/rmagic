require "game_helper"

RSpec.describe Library::Vaporkin, type: :card do
  let(:duel) { create_game }
  let(:attacker) { available_attackers.first }
  let(:defenders) { action_finder.defendable_cards(player2) }

  before :each do
    create_card player2.battlefield, Library::Vaporkin
  end

  context "with a normal creature attacking" do
    before { create_card player1.battlefield, Library::BasicCreature }

    context "in attacking phase" do
      before { duel.attacking_phase! }

      it "we have an attacker" do
        expect(attacker).to_not be_nil
      end

      it "the attacker is the basic creature" do
        expect(attacker.card.card_type.name).to eq("Basic creature")
      end

      context "and declared an attacker" do
        before { declare_attackers [attacker] }

        context "after passing priority" do
          before { pass_priority }

          it "we have no available defenders" do
            expect(defenders).to be_empty
          end

          context "when we have a normal flyer" do
            before { create_card player2.battlefield, Library::SuntailHawk }

            it "we have an available defender" do
              expect(defenders.length).to eq(1)
            end

            it "we can defend with our card" do
              expect(defenders.first.source).to eq(player2.battlefield_creatures.second)
            end
          end
        end
      end
    end
  end

  context "with a flying creature attacking" do
    before { create_card player1.battlefield, Library::SuntailHawk }

    context "in attacking phase" do
      before { duel.attacking_phase! }

      context "and declared an attacker" do
        before { declare_attackers [attacker] }

        context "after passing priority" do
          before { pass_priority }

          it "we have one available defenders" do
            expect(defenders.length).to eq(1)
          end
        end
      end
    end
  end

  context "with a Vaporkin creature attacking" do
    before { create_card player1.battlefield, Library::Vaporkin }

    context "in attacking phase" do
      before { duel.attacking_phase! }

      context "and declared an attacker" do
        before { declare_attackers [attacker] }

        context "after passing priority" do
          before { pass_priority }

          it "we have one available defenders" do
            expect(defenders.length).to eq(1)
          end
        end
      end
    end
  end

end
