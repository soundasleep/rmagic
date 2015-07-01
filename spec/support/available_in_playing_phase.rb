RSpec.shared_examples "available in playing phase" do

  context "in our turn" do
    context "in the playing phase" do
      before :each do
        duel.playing_phase!
        tap_all_lands
      end

      it "can be activated" do
        expect(available_abilities).to_not be_empty
      end
    end
  end

end
