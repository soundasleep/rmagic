RSpec.shared_examples "targeted ability" do
  let(:cost) { source.card.card_type.action_cost(game_engine, targeted_ability) }

  it_behaves_like "not available in drawing phases"
  it_behaves_like "available in playing phases"
  it_behaves_like "available in attacking phases"
  it_behaves_like "not available in cleanup phases"

  context "the source" do
    let(:source_actions) { source.card.card_type.actions }

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
      it "can be played" do
        expect(game_engine).to be_can_do_action(targeted_ability)
      end
    end

    context "without a target" do
      it "cannot be played" do
        expect(game_engine).to_not be_can_do_action(ability)
      end
    end

    context "is listed as an available action" do
      it "of one type" do
        expect(available_abilities.to_a.uniq{ |u| u.source }.length).to eq(1)
      end

      it "of two targets" do
        expect(available_abilities.length).to eq(2)
      end

      it "with the correct source and key" do
        available_actions[:play].each do |a|
          expect(a.source).to eq(source)
          expect(a.key).to eq(ability_key)
        end
      end
    end

    it "all actions have source and key and target specified" do
      available_actions[:play].each do |a|
        expect(a.source).to_not be_nil
        expect(a.key).to_not be_nil
        expect(a.target).to_not be_nil
      end
    end

    it "all actions have a description" do
      available_actions[:play].each do |a|
        expect(a.description).to_not be_nil
      end
    end
  end
end
