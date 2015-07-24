require 'rails_helper'

RSpec.describe Library, type: :library do
  let(:library) { Library.new }

  context "card types" do
    let(:card_types) { library.card_types }

    it "are defined" do
      expect(card_types).to_not be_empty
    end
  end

  context "effects" do
    let(:effect_types) { library.effect_types }

    it "are defined" do
      expect(effect_types).to_not be_empty
    end
  end

  context "#duplicate_metaverses" do
    context "with duplicates" do
      let(:duplicates) { [Library::BasicCreature, Library::Forest, Library::BasicCreature] }

      it "returns a value" do
        expect(library.duplicate_metaverses(duplicates)).to eq(Library::BasicCreature.metaverse_id)
      end
    end

    context "with duplicates" do
      let(:duplicates) { [Library::BasicCreature, Library::Forest] }

      it "returns nil" do
        expect(library.duplicate_metaverses(duplicates)).to be(nil)
      end
    end
  end
end
