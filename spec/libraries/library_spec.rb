require 'rails_helper'

RSpec.describe Library, type: :library do
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

    it "each have a class metaverse id equal to metaverse id" do
      card_types.each do |id, card_type|
        expect(card_type.new.metaverse_id).to eq(card_type.new.class.metaverse_id)
      end
    end

    it "each have a description" do
      card_types.each do |id, card_type|
        expect(card_type.new.to_text).to_not be_nil
      end
    end

    context "each action" do
      it "has a cost" do
        card_types.values.each do |card_type|
          card = card_type.new
          card.actions.each do |a|
            expect(card.action_cost(a)).to_not be_nil
          end
        end
      end

      it "has a condition" do
        card_types.values.each do |card_type|
          card = card_type.new
          card.actions.each do |a|
            expect(card.conditions_for(a)).to_not be_nil
          end
        end
      end

      it "has an action" do
        card_types.values.each do |card_type|
          card = card_type.new
          card.actions.each do |a|
            expect(card.actions_for(a)).to_not be_nil
          end
        end
      end
    end

    context "actions that go onto the stack" do
      it "have a #do_ method defined" do
        card_types.values.each do |card_type|
          card = card_type.new
          card.actions.each do |a|
            if card.playing_goes_onto_stack?(a)
              expect(card.methods.map(&:to_s)).to include("do_#{a}"), "#{card_type}: Action #{a} which resolves on the stack should have a `do_#{a}`"
            end
          end
        end
      end
    end

    context "actions that do not go onto the stack" do
      it "have a #rdo_ method defined" do
        card_types.values.each do |card_type|
          card = card_type.new
          card.actions.each do |a|
            if !card.playing_goes_onto_stack?(a)
              expect(card.methods.map(&:to_s)).to include("do_#{a}"), "#{card_type}: Action #{a} which does not interact on the stack should have a `do_#{a}`"
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

    it "each have a class effect id equal to effect id" do
      effect_types.each do |id, effect|
        expect(effect.new.effect_id).to eq(effect.new.class.effect_id)
      end
    end

    it "each have a description" do
      effect_types.each do |id, effect|
        expect(effect.new.to_text).to_not be_nil
      end
    end
  end

  context "#duplicate_metaverses" do
    context "with duplicates" do
      let(:duplicates) { [Library::Metaverse1, Library::Forest, Library::Metaverse1] }

      it "returns a value" do
        expect(library.duplicate_metaverses(duplicates)).to eq(Library::Metaverse1.metaverse_id)
      end
    end

    context "with duplicates" do
      let(:duplicates) { [Library::Metaverse1, Library::Forest] }

      it "returns nil" do
        expect(library.duplicate_metaverses(duplicates)).to be(nil)
      end
    end
  end

end
