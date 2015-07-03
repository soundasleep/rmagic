require_relative "setup_game"

RSpec.describe "Priority", type: :game do
  let(:duel) { create_game }

  let(:instant) { duel.player1.hand.select{ |b| b.card.card_type.actions.include?("instant") }.first }
  let(:play_instant) { PossibleAbility.new(source: instant, key: "instant") }

  let(:counter_spell) { duel.player1.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }

  let(:stack) { duel.stack }

  before :each do
    create_hand_cards Library::Metaverse4
    create_hand_cards Library::CounterSpell
  end

  context "a normal instant" do
    before { duel.playing_phase! }

    context "the duel" do
      it "is in playing phase" do
        expect(duel).to be_playing_phase
      end
    end

    context "with mana" do
      before { tap_all_lands }

      it "the player has 3 mana" do
        expect(duel.player1.mana_green).to eq(3)
      end

      context "when played" do
        before { game_engine.card_action(play_instant) }

        context "the duel" do
          it "is in playing phase" do
            expect(duel).to be_playing_phase
          end
        end

        # 116.3c "If a player has priority when he or she casts a spell,
        # activates an ability, or takes a special action, that player
        # receives priority afterward."
        it "we still have priority" do
          expect(duel.priority_player).to eq(duel.player1)
        end

        it "the stack is not empty" do
          expect(stack).to_not be_empty
        end

        it "player 1 has 2 mana" do
          expect(duel.player1.mana_green).to eq(2)
        end

        context "our counterspell" do
          let(:counter_spell) { duel.player1.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }
          let(:play_counter_spell) { PossibleAbility.new(source: counter_spell, key: "counter") }

          context "when played" do
            before { game_engine.card_action(play_counter_spell) }

            it "we still have priority" do
              expect(duel.priority_player).to eq(duel.player1)
            end
          end
        end

        context "after passing priority" do
          before { pass_priority }

          context "the duel" do
            it "is in playing phase" do
              expect(duel).to be_playing_phase
            end
          end

          it "player 1 still has 2 mana" do
            expect(duel.player1.mana_green).to eq(2)
          end

          it "the second player has priority" do
            expect(duel.priority_player).to eq(duel.player2)
          end

          context "after passing priority" do
            before { pass_priority }

            it "we have priority again" do
              expect(duel.priority_player).to eq(duel.player1)
            end
          end

          context "playing their counterspell" do
            let(:counter_spell) { duel.player2.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }
            let(:play_counter_spell) { PossibleAbility.new(source: counter_spell, key: "counter") }

            context "with mana" do
              before { tap_all_lands }

              it "player 2 has 3 mana" do
                expect(duel.player2.mana_green).to eq(3)
              end

              it "player 1 has 2 mana" do
                expect(duel.player1.mana_green).to eq(2)
              end

              it "player 2 still has priority" do
                expect(duel.priority_player).to eq(duel.player2)
              end

              context "when played" do
                before { game_engine.card_action(play_counter_spell) }

                context "the duel" do
                  it "is in playing phase" do
                    expect(duel).to be_playing_phase
                  end
                end

                it "player one immediately gets priority again" do
                  expect(duel.priority_player).to eq(duel.player1)
                end

                it "player 1 has 2 mana" do
                  expect(duel.player1.mana_green).to eq(2)
                end

                context "after passing priority" do
                  before { pass_priority }

                  context "the duel" do
                    it "is in playing phase" do
                      expect(duel).to be_playing_phase
                    end
                  end

                  context "after passing priority" do
                    before { pass_priority }

                    context "the duel" do
                      it "is not in playing phase" do
                        expect(duel).to_not be_playing_phase
                      end
                    end

                    it "the stack is empty" do
                      expect(stack).to be_empty
                    end
                  end
                end

                context "our counterspell" do
                  let(:our_counter_spell) { duel.player1.hand.select{ |b| b.card.card_type.actions.include?("counter") }.first }

                  context "targeting our spell" do
                    let(:another_counter_spell) { PossibleAbility.new(source: our_counter_spell, key: "counter") }

                    it "player 1 has 2 mana" do
                      expect(duel.player1.mana_green).to eq(2)
                    end

                    context "the duel" do
                      it "is in playing phase" do
                        expect(duel).to be_playing_phase
                      end
                    end

                    context "when played" do
                      before { game_engine.card_action(another_counter_spell) }

                      it "we still have priority" do
                        expect(duel.priority_player).to eq(duel.player1)
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
