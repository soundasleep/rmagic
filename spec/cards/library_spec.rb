require 'rails_helper'

RSpec.describe Library, type: :card do
  let(:library) { Library.new }

  context "card types" do
    let(:card_types) { library.card_types }

    it "exist" do
      expect(card_types).to_not be_empty
    end

    it "each have a metaverse id" do
      card_types.each do |id, card_type|
        expect(card_type.new.metaverse_id).to_not be_nil
      end
    end

    it "each have a description" do
      card_types.each do |id, card_type|
        expect(card_type.new.to_text).to_not be_nil
      end
    end
  end

  context "effects" do
    let(:effect_types) { library.effect_types }

    it "exist" do
      expect(effect_types).to_not be_empty
    end

    it "each have an effect id" do
      effect_types.each do |id, effect|
        expect(effect.new.effect_id).to_not be_nil
      end
    end

    it "each have a description" do
      effect_types.each do |id, effect|
        expect(effect.new.to_text).to_not be_nil
      end
    end
  end

  context "#duplicates" do
    context "with duplicates" do
      let(:duplicates) { [Library::Metaverse1, Library::Forest, Library::Metaverse1] }

      it "returns a value" do
        expect(library.duplicates(duplicates)).to eq(Library::Metaverse1.id)
      end
    end

    context "with duplicates" do
      let(:duplicates) { [Library::Metaverse1, Library::Forest] }

      it "returns nil" do
        expect(library.duplicates(duplicates)).to be(nil)
      end
    end
  end

end
