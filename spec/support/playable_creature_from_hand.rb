RSpec.shared_examples "playable creature from hand" do

  let(:ability_key) { "play" }
  let(:source) { player1.hand.select{ |b| b.card.card_type.actions.include?(ability_key) }.first }
  let(:ability) { PossiblePlay.new(source: source, key: ability_key) }
  let(:targeted_ability) { PossiblePlay.new(source: source, key: ability_key, target: source) }
  let(:available_abilities) { available_play_actions(ability_key) }

  let(:cost) { source.card.card_type.action_cost(game_engine, ability) }

  context "the source" do
    let(:source_actions) { source.card.card_type.actions }

    it "exists" do
      expect(source).to_not be_nil
    end

    it "has the action" do
      expect(source_actions).to include(ability_key)
    end
  end

  context "without mana" do
    context "with a target" do
      it "cannot be played" do
        expect(game_engine).to_not be_can_do_action(targeted_ability)
      end
    end

    context "without a target" do
      it "cannot be played" do
        expect(game_engine).to_not be_can_do_action(ability)
      end
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    context "with a target" do
      it "cannot be played" do
        expect(game_engine).to_not be_can_do_action(targeted_ability)
      end
    end

    context "without a target" do
      it "can be played" do
        expect(game_engine).to be_can_do_action(ability)
      end
    end

    context "is listed as an available action" do
      it "of one type" do
        expect(available_abilities.to_a.uniq{ |u| u.source }.length).to eq(1)
      end

      it "of one type" do
        expect(available_abilities.length).to eq(1)
      end

      it "with the correct source and key" do
        available_actions[:play].each do |a|
          expect(a.source).to eq(source)
          expect(a.key).to eq(ability_key)
        end
      end
    end

    it "all actions have source and key specified" do
      available_actions[:play].each do |a|
        expect(a.source).to_not be_nil
        expect(a.key).to_not be_nil
        expect(a.target).to be_nil
      end
    end

    it "all actions have a description" do
      available_actions[:play].each do |a|
        expect(a.description).to_not be_nil
      end
    end
  end

  context "before playing the creature" do
    it "the battlefield is empty" do
      expect(creature).to be_nil
    end
  end

  context "without mana" do
    it "requires mana" do
      expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "play"))).to be(false)
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    it "provides 3 green mana" do
      expect(duel.player1.mana_green).to eq(3)
    end

    it "can be played with mana" do
      expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "play"))).to be(true)
    end

    context "when played" do
      before :each do
        game_engine.card_action(PossiblePlay.new(source: card, key: "play"))
      end

      it "adds a creature to the battlefield" do
        expect(creature).to_not be_nil
      end

      it "is turn 1" do
        expect(duel.turn).to eq(1)
      end

      context "the creature" do
        it "is played on turn 1" do
          expect(creature.card.turn_played).to eq(1)
        end
      end

      it "consumes mana" do
        expect(duel.player1.mana_green).to eq(1)
      end

      it "removes the creature from the hand" do
        expect(duel.player1.hand).to be_empty
      end
    end
  end

end
