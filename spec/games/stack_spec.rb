require "game_helper"

RSpec.describe "The stack", type: :game do
  let(:duel) { create_game }
  let(:source) { duel.player1.hand.select{ |b| b.card.card_type.actions.include?("instant") }.first }
  let(:instant_ability) { PossibleAbility.new(source: source, key: "instant") }

  let(:stack) { duel.stack }

  before :each do
    create_hand_cards Library::Metaverse4
    create_hand_cards Library::CounterSpell
    duel.playing_phase!
  end

  def instant_actions(zone_card)
    actions(zone_card.card, "instant")
  end

  def first_instant_available_actions
    available_play_actions("instant")
  end

  it "starts empty" do
    expect(stack).to be_empty
  end

  context "with mana" do
    before { tap_all_lands }

    context "when played" do
      before :each do
        instant_ability.do duel
      end

      context "the stack" do
        it "is not empty" do
          expect(stack).to_not be_empty
        end

        it "contains the card" do
          expect(stack.map{ |s| s.card }).to eq([source.card])
        end
      end

        context "our counterspell" do
        let(:counter_spell) { duel.player1.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }
        let(:play_counter_spell) { PossibleAbility.new(source: counter_spell, key: "counter") }

        context "when played" do
          before { play_counter_spell.do duel }

          it "contains both cards" do
            expect(stack.map{ |s| s.card }).to eq([source.card, counter_spell.card])
          end

          it "contains the cards in order" do
            expect(stack.first.card).to eq(source.card)
            expect(stack.second.card).to eq(counter_spell.card)
          end
        end
      end

      context "after passing priority" do
        before { pass_priority }

        it "the stack is not empty" do
          expect(stack).to_not be_empty
        end

        context "after passing priority" do
          before { pass_priority }

          it "clears the stack" do
            expect(stack).to be_empty
          end
        end
      end

      context "in the next phase" do
        before { pass_until_next_phase }

        it "clears the stack" do
          expect(stack).to be_empty
        end
      end
    end
  end

end
