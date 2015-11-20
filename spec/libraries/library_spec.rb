require 'rails_helper'

RSpec.describe Library, type: :library do
  let(:library) { Library.new }

  describe "#card_types" do
    let(:card_types) { library.card_types }

    it "are defined" do
      expect(card_types).to_not be_empty
    end
  end

  describe "#effect_types" do
    let(:effect_types) { library.effect_types }

    it "are defined" do
      expect(effect_types).to_not be_empty
    end
  end

  describe "#duplicate_metaverses" do
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

  describe "#find_card" do
    it "can find Island" do
      expect(library.find_card("Island")).to eq(Library::Island)
      expect(library.find_card("Island")).to_not eq(Library::Forest)
    end

    it "can find Kiora's Follower" do
      expect(library.find_card("Kiora's Follower")).to eq(Library::KiorasFollower)
    end

    it "fails with a card that it can't find" do
      expect { library.find_card("asdfzxcv") }.to raise_error(Library::NoSuchCardError)
    end
  end
end
