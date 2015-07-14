require "game_helper"

RSpec.describe "Counterspells", type: :game do
  let(:duel) { create_game }

  let(:instant) { duel.player1.hand.select{ |b| b.card.card_type.actions.include?("instant") }.first }
  let(:play_instant) { PossibleAbility.new(source: instant, key: "instant") }

  let(:stack) { duel.stack }

  before :each do
    create_hand_cards Library::Metaverse4
    create_hand_cards Library::CounterSpell
  end

  context "a counter spell" do
    before { duel.playing_phase! }

    context "without a target" do
      let(:counter_spell) { duel.player1.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }
      let(:play_counter_spell) { PossibleAbility.new(source: counter_spell, key: "counter") }

      context "without mana" do
        it "cannot be played" do
          expect(play_counter_spell.can_do?(duel)).to be(false)
        end
      end

      context "with mana" do
        before { tap_all_lands }

        it "cannot be played" do
          # because we don't have any cards in the stack
          expect(play_counter_spell.can_do?(duel)).to be(false)
        end
      end
    end

  end

  context "a normal instant" do
    before { duel.playing_phase! }

    context "without mana" do
      it "cannot be played" do
        expect(play_instant.can_do?(duel)).to be(false)
      end
    end

    context "with mana" do
      before { tap_all_lands }

      it "can be played" do
        expect(play_instant.can_do?(duel)).to be(true)
      end

      context "when played" do
        before { play_instant.do duel }

        # 116.3c "If a player has priority when he or she casts a spell,
        # activates an ability, or takes a special action, that player
        # receives priority afterward."
        it "we still have priority" do
          expect(duel.priority_player).to eq(duel.player1)
        end

        context "in the current phase" do
          it "we have 20 life" do
            expect(duel.player1.life).to eq(20)
          end
        end

        context "after passing to next phase" do
          before { pass_until_next_phase }

          it "gives us 1 life" do
            expect(duel.player1.life).to eq(21)
          end
        end

        context "our counterspell" do
          let(:counter_spell) { duel.player1.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }

          context "without a target" do
            let(:play_counter_spell) { PossibleAbility.new(source: counter_spell, key: "counter") }

            it "the stack is not empty" do
              expect(duel.stack).to_not be_empty
            end

            it "can be played" do
              expect(play_counter_spell.can_do?(duel)).to be(true)
            end

            context "when played" do
              before { play_counter_spell.do duel }

              it "we still have priority" do
                expect(duel.priority_player).to eq(duel.player1)
              end

              context "in the current phase" do
                it "we have 20 life" do
                  expect(duel.player1.life).to eq(20)
                end
              end

              context "after passing to next phase" do
                before { pass_until_next_phase }

                it "we have 20 life" do
                  expect(duel.player1.life).to eq(20)
                  # i.e. the spell has been countered
                end
              end
            end
          end

          context "with a target" do
            let(:target) { stack.first }
            let(:play_counter_spell) { PossibleAbility.new(source: counter_spell, key: "counter", target: target) }

            it "our target is the first instant" do
              expect(target.card).to eq(instant.card)
            end

            it "cannot be played" do
              expect(play_counter_spell.can_do?(duel)).to be(false)
            end
          end
        end

        context "after passing priority" do
          before { pass_priority }

          it "the second player has priority" do
            expect(duel.priority_player).to eq(duel.player2)
          end

          context "after passing priority" do
            before { pass_priority }

            it "we have priority again" do
              expect(duel.priority_player).to eq(duel.player1)
            end
          end

          context "their counterspell" do
            let(:their_counter_spell) { duel.player2.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }

            context "targeting our spell" do
              let(:play_their_counter_spell) { PossibleAbility.new(source: their_counter_spell, key: "counter") }

              context "without mana" do
                it "cannot be played" do
                  expect(play_their_counter_spell.can_do?(duel)).to be(false)
                end
              end

              context "with mana" do
                before { tap_all_lands }

                it "can be played" do
                  expect(play_their_counter_spell.can_do?(duel)).to be(true)
                end

                context "when played" do
                  before { play_their_counter_spell.do duel }

                  it "player one immediately gets priority again" do
                    expect(duel.priority_player).to eq(duel.player1)
                  end

                  context "in the current phase" do
                    it "we have 20 life" do
                      expect(duel.player1.life).to eq(20)
                    end

                    it "the stack is not empty" do
                      expect(stack).to_not be_empty
                    end
                  end

                  context "after passing to next phase" do
                    before { pass_until_next_phase }

                    it "we have 20 life" do
                      expect(duel.player1.life).to eq(20)
                      # i.e. the spell has been countered
                    end

                  end

                  context "after passing priority" do
                    before { pass_priority }

                    context "after passing priority" do
                      before { pass_priority }

                      it "we have 20 life" do
                        expect(duel.player1.life).to eq(20)
                      end
                    end
                  end

                  context "our second counterspell" do
                    let(:our_counter_spell) { duel.player1.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }

                    context "targeting our spell" do
                      let(:play_our_counter_spell) { PossibleAbility.new(source: our_counter_spell, key: "counter") }

                      # player1 has already tapped all their lands
                      it "can be played" do
                        expect(play_our_counter_spell.can_do?(duel)).to be(true)
                      end

                      context "when played" do
                        before { play_our_counter_spell.do duel }

                        context "in the current phase" do
                          it "we have 20 life" do
                            expect(duel.player1.life).to eq(20)
                          end
                        end

                        context "after passing to next phase" do
                          before { pass_until_next_phase }

                          it "we have 21 life" do
                            expect(duel.player1.life).to eq(21)
                            # i.e. the counterspell has been countered
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

end
