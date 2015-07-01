RSpec.shared_examples "not available in cleanup phase" do

  context "in our turn" do
    context "in the cleanup phase" do
      before :each do
        duel.cleanup_phase!
        tap_all_lands
      end

      it "cannot be activated" do
        expect(available_abilities).to be_empty
      end
    end
  end

end
