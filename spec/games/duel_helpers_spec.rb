require_relative "setup_game"

RSpec.describe Duel, type: :game do
  let(:duel) { create_game }

  context "#player1" do

    context "#battlefield" do
      it "contains three cards" do
        expect(duel.player1.battlefield.length).to eq(3)
      end

      it "contains three lands" do
        expect(duel.player1.battlefield_lands.length).to eq(3)
      end

      it "contains zero creatures" do
        expect(duel.player1.battlefield_creatures.length).to eq(0)
      end

      context "adding a creature" do
        before :each do
          create_battlefield_cards Library::Metaverse1.id
        end

        it "contains four cards" do
          expect(duel.player1.battlefield.length).to eq(4)
        end

        it "contains three lands" do
          expect(duel.player1.battlefield_lands.length).to eq(3)
        end

        it "contains one creature" do
          expect(duel.player1.battlefield_creatures.length).to eq(1)
        end
      end
    end

    context "#hand" do
      it "contains zero creatures" do
        expect(duel.player1.hand.length).to eq(0)
      end

      it "contains zero lands" do
        expect(duel.player1.hand_lands.length).to eq(0)
      end

      it "contains zero creatures" do
        expect(duel.player1.hand_creatures.length).to eq(0)
      end

      context "adding a creature" do
        before :each do
          create_hand_cards Library::Metaverse1.id
        end

        it "contains one card" do
          expect(duel.player1.hand.length).to eq(1)
        end

        it "contains zero lands" do
          expect(duel.player1.hand_lands.length).to eq(0)
        end

        it "contains one creature" do
          expect(duel.player1.hand_creatures.length).to eq(1)
        end
      end
    end

  end

end
