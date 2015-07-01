RSpec.shared_examples "available in attacking phases" do

  context "in our turn" do
    context "in the attacking phase" do
      before :each do
        duel.attacking_phase!
        tap_all_lands
      end

      it "can be activated" do
        expect(available_abilities).to_not be_empty
      end
    end
  end

  context "in the other player's turn" do
    before { pass_until_next_player }

    context "in the attacking phase" do
      before :each do
        duel.attacking_phase!
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

      context "in the attacking phase" do
        before :each do
          duel.attacking_phase!
          tap_all_lands
        end

        it "can be activated" do
          expect(available_abilities).to_not be_empty
        end
      end
    end
  end

end
