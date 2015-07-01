RSpec.shared_examples "requires mana" do
  let(:cost) { source.card.card_type.action_cost(game_engine, ability) }

  context "without mana" do
    it "is not enough mana to play" do
      expect(player1).to_not have_mana(cost)
    end

    it "is not an available ability" do
      expect(game_engine).to_not be_can_do_action(ability)
    end

    it "is not listed as an available action" do
      expect(available_abilities).to be_empty
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    it "is enough mana to play" do
      expect(player1).to be_has_mana(cost)
    end
  end
end
