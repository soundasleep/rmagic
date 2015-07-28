require "game_helper"

RSpec.describe Library::LightningStrike, type: :card do
  let(:duel) { create_game }

  before :each do
    create_hand_cards Library::LightningStrike
    create_battlefield_cards Library::ElvishMystic
    create_battlefield_cards Library::Mountain
    duel.playing_phase!
  end

  context "without a target creature" do
    let(:instant) { player1.hand.select { |c| c.card.card_type.actions.include?("instant_creature") }.first }
    let(:play_instant) { PlayAction.new(source: instant, key: "instant_creature") }
    let(:play_conditions) { play_instant.conditions }
    let(:play_result) { play_conditions.evaluate_with(duel) }

    it "cannot be played" do
      expect(play_result.evaluate).to be(false), play_result.explain
    end
  end

  context "without a target player" do
    let(:instant) { player1.hand.select { |c| c.card.card_type.actions.include?("instant_player") }.first }
    let(:play_instant) { PlayAction.new(source: instant, key: "instant_player") }
    let(:play_conditions) { play_instant.conditions }
    let(:play_result) { play_conditions.evaluate_with(duel) }

    it "cannot be played" do
      expect(play_result.evaluate).to be(false), play_result.explain
    end
  end

  context "with a target player" do
    let(:target) { player2 }
    let(:instant) { player1.hand.select { |c| c.card.card_type.actions.include?("instant_player") }.first }
    let(:play_instant) { PlayAction.new(source: instant, key: "instant_player", target: target) }
    let(:play_conditions) { play_instant.conditions }
    let(:play_result) { play_conditions.evaluate_with(duel) }

    it "the stack is empty" do
      expect(duel.stack).to be_empty
    end

    it "player 2 has 20 life" do
      expect(player2.life).to eq(20)
    end

    context "with mana" do
      before { tap_all_lands }

      it "can be played" do
        expect(play_result.evaluate).to be(true), play_result.explain
      end

      context "when played" do
        before { play_instant.do(duel) }

        it "goes on the stack" do
          expect(duel.stack).to_not be_empty
        end

        it "player 2 has 20 life" do
          expect(player2.life).to eq(20)
        end

        context "when the stack resolves" do
          before { pass_until_stack_resolves }

          it "player 2 has 17 life" do
            expect(player2.life).to eq(17)
          end

          it "the stack is empty" do
            expect(duel.stack).to be_empty
          end
        end
      end
    end
  end

  context "with a target creature" do
    let(:target) { player2.battlefield_creatures.first }
    let(:instant) { player1.hand.select { |c| c.card.card_type.actions.include?("instant_creature") }.first }
    let(:play_instant) { PlayAction.new(source: instant, key: "instant_creature", target: target) }
    let(:play_conditions) { play_instant.conditions }
    let(:play_result) { play_conditions.evaluate_with(duel) }

    it "the stack is empty" do
      expect(duel.stack).to be_empty
    end

    it "the creature is on the battlefield" do
      expect(player2.battlefield.map(&:card)).to include(target.card)
    end

    context "with mana" do
      before { tap_all_lands }

      it "can be played" do
        expect(play_result.evaluate).to be(true), play_result.explain
      end

      context "when played" do
        before { play_instant.do(duel) }

        it "goes on the stack" do
          expect(duel.stack).to_not be_empty
        end

        it "the creature is on the battlefield" do
          expect(player2.battlefield.map(&:card)).to include(target.card)
        end

        context "when the stack resolves" do
          before { pass_until_stack_resolves }

          it "the creature is not on the battlefield" do
            expect(player2.battlefield.map(&:card)).to_not include(target.card)
          end

          it "the creature is on the graveyard" do
            expect(player2.graveyard.map(&:card)).to include(target.card)
          end

          it "the stack is empty" do
            expect(duel.stack).to be_empty
          end
        end
      end
    end
  end

end
