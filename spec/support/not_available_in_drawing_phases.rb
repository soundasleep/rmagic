RSpec.shared_examples "not available in drawing phases" do

  let(:available_abilities) { available_ability_actions(ability_key) }

  context "in our turn" do
    context "in the drawing phase" do
      before :each do
        duel.drawing_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(available_abilities).to be_empty
      end
    end
  end

  context "in the other player's turn" do
    before { pass_until_next_player }

    context "in the drawing phase" do
      before :each do
        duel.drawing_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(available_abilities).to be_empty
      end
    end

    context "when we have priority" do
      before :each do
        pass_until_current_player_has_priority
      end

      context "in the drawing phase" do
        before :each do
          duel.drawing_phase!
          tap_all_lands
        end

        it "cannot be activated" do
          expect(available_abilities).to be_empty
        end
      end
    end
  end

end
