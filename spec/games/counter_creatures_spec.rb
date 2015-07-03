require_relative "setup_game"

RSpec.describe "Counterspells on creatures", type: :game do
  let(:duel) { create_game }

  let(:creature) { player1.hand.select{ |b| b.card.card_type.actions.include?("play") }.first }
  let(:play_creature) { PossiblePlay.new(source: creature, key: "play") }

  let(:stack) { duel.stack }

  before :each do
    create_hand_cards Library::Metaverse1
    create_hand_cards Library::CounterCreature
    create_hand_cards Library::CounterSpell
  end

  context "a normal creature" do
    before { duel.playing_phase! }

    context "without mana" do
      it "cannot be played" do
        expect(game_engine.can_do_action?(play_creature)).to be(false)
      end
    end

    context "with mana" do
      before { tap_all_lands }

      it "can be played" do
        expect(game_engine.can_do_action?(play_creature)).to be(true)
      end

      context "when played" do
        before { game_engine.card_action(play_creature) }

        # 116.3c "If a player has priority when he or she casts a spell,
        # activates an ability, or takes a special action, that player
        # receives priority afterward."
        it "we still have priority" do
          expect(duel.priority_player).to eq(player1)
        end

        context "in the current phase" do
          it "the battlefield is empty" do
            expect(player1.battlefield_creatures).to be_empty
          end
        end

        context "after passing to next phase" do
          before { pass_until_next_phase }

          it "the battlefield is not empty" do
            expect(player1.battlefield_creatures).to_not be_empty
          end
        end

        context "our counter spell" do
          let(:counter_spell) { player1.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }

          context "without a target" do
            let(:play_counter_spell) { PossibleAbility.new(source: counter_spell, key: "counter") }

            # counterspells cannot target creatures
            it "can not be played" do
              expect(game_engine.can_do_action?(play_counter_spell)).to be(false)
            end
          end
        end

        context "our counter creature" do
          let(:counter_creature) { player1.hand.select{ |b| b.card.card_type.actions.include?("counter_creature") }.first }

          context "without a target" do
            let(:play_counter_creature) { PossibleAbility.new(source: counter_creature, key: "counter_creature") }

            it "the stack is not empty" do
              expect(duel.stack).to_not be_empty
            end

            it "can be played" do
              expect(game_engine.can_do_action?(play_counter_creature)).to be(true)
            end

            context "when played" do
              before { game_engine.card_action(play_counter_creature) }

              it "we still have priority" do
                expect(duel.priority_player).to eq(player1)
              end

              context "in the current phase" do
                it "the battlefield is empty" do
                  expect(player1.battlefield_creatures).to be_empty
                end
              end

              context "after passing to next phase" do
                before { pass_until_next_phase }

                it "the battlefield is empty" do
                  expect(player1.battlefield_creatures).to be_empty
                  # i.e. the creature has been countered
                end
              end
            end
          end

          context "with a target" do
            let(:target) { stack.first }
            let(:play_counter_creature) { PossibleAbility.new(source: counter_creature, key: "counter_creature", target: target) }

            it "our target is the first creature" do
              expect(target.card).to eq(creature.card)
            end

            it "cannot be played" do
              expect(game_engine.can_do_action?(play_counter_creature)).to be(false)
            end
          end
        end

        context "after passing priority" do
          before { pass_priority }

          it "the second player has priority" do
            expect(duel.priority_player).to eq(player2)
          end

          context "after passing priority" do
            before { pass_priority }

            it "we have priority again" do
              expect(duel.priority_player).to eq(player1)
            end
          end

          context "their counter creature" do
            let(:their_counter_creature) { player2.hand.select{ |b| b.card.card_type.actions.include?("counter_creature") }.first }

            context "targeting our spell" do
              let(:play_their_counter_creature) { PossibleAbility.new(source: their_counter_creature, key: "counter_creature") }

              context "without mana" do
                it "cannot be played" do
                  expect(game_engine.can_do_action?(play_their_counter_creature)).to be(false)
                end
              end

              context "with mana" do
                before { tap_all_lands }

                it "can be played" do
                  expect(game_engine.can_do_action?(play_their_counter_creature)).to be(true)
                end

                context "when played" do
                  before { game_engine.card_action(play_their_counter_creature) }

                  it "player one immediately gets priority again" do
                    expect(duel.priority_player).to eq(player1)
                  end

                  context "in the current phase" do
                    it "the battlefield is empty" do
                      expect(player1.battlefield_creatures).to be_empty
                    end

                    it "the stack is not empty" do
                      expect(stack).to_not be_empty
                    end
                  end

                  context "after passing to next phase" do
                    before { pass_until_next_phase }

                    it "the battlefield is empty" do
                      expect(player1.battlefield_creatures).to be_empty
                      # i.e. the creature has been countered
                    end
                  end

                  context "after passing priority" do
                    before { pass_priority }

                    context "after passing priority" do
                      before { pass_priority }

                      it "the battlefield is empty" do
                        expect(player1.battlefield_creatures).to be_empty
                      end
                    end
                  end

                  context "our counter spell" do
                    let(:our_counter_spell) { player1.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }

                    context "targeting our spell" do
                      let(:play_our_counter_spell) { PossibleAbility.new(source: our_counter_spell, key: "counter") }

                      # player1 has already tapped all their lands
                      it "can be played" do
                        expect(game_engine.can_do_action?(play_our_counter_spell)).to be(true)
                      end

                      context "when played" do
                        before { game_engine.card_action(play_our_counter_spell) }

                        context "in the current phase" do
                          it "the battlefield is empty" do
                            expect(player1.battlefield_creatures).to be_empty
                          end
                        end

                        context "after passing to next phase" do
                          before { pass_until_next_phase }

                          it "the battlefield is not empty" do
                            expect(player1.battlefield_creatures).to_not be_empty
                            # i.e. the counter creature has been countered with the counter spell
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
