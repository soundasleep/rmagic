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

    it "each have an id equal to metaverse id" do
      card_types.each do |id, card_type|
        expect(card_type.new.metaverse_id).to eq(card_type.new.id)
      end
    end

    it "each have a class id equal to metaverse id" do
      card_types.each do |id, card_type|
        expect(card_type.new.metaverse_id).to eq(card_type.new.class.id)
      end
    end

    it "each have a description" do
      card_types.each do |id, card_type|
        expect(card_type.new.to_text).to_not be_nil
      end
    end

    context "actions that go onto the stack" do
      it "do not have a #do_ method defined" do
        card_types.values.each do |card_type|
          card = card_type.new
          card.actions.each do |a|
            if card.playing_goes_onto_stack?(a)
              expect(card.methods.map(&:to_s)).to_not include("do_#{a}"), "#{card_type}: Action #{a} which resolves on the stack should not have a `do_#{a}`"
            end
          end
        end
      end
    end

    context "actions that do not go onto the stack" do
      it "do not have a #resolve_ method defined" do
        card_types.values.each do |card_type|
          card = card_type.new
          card.actions.each do |a|
            if !card.playing_goes_onto_stack?(a)
              expect(card.methods.map(&:to_s)).to_not include("resolve_#{a}"), "#{card_type}: Action #{a} which does not interact on the stack should not have a `resolve_#{a}`"
            end
          end
        end
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

    it "each have an id equal to effect id" do
      effect_types.each do |id, effect|
        expect(effect.new.effect_id).to eq(effect.new.id)
      end
    end

    it "each have a class id equal to effect id" do
      effect_types.each do |id, effect|
        expect(effect.new.effect_id).to eq(effect.new.class.id)
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
