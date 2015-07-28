require 'rails_helper'

Library.new.card_types.each do |id, card_type|
  RSpec.describe card_type, type: :library do
    instance = card_type.new

    let(:methods) { instance.methods.map(&:to_s) }

    it "has a metaverse id" do
      expect(instance.metaverse_id).to_not be_nil
    end

    it "has a class metaverse id equal to metaverse id" do
      expect(instance.metaverse_id).to eq(instance.class.metaverse_id)
    end

    it "has a description" do
      expect(instance.to_text).to_not be_nil
    end

    it "has actions" do
      expect(instance.actions).to_not be_empty
    end

    instance.actions.each do |action|
      context "defined action #{action}" do
        it "has a cost" do
          expect(instance.action_cost(action)).to_not be_nil
        end

        it "has a condition" do
          expect(instance.conditions_for(action)).to_not be_nil
        end

        it "has an action" do
          expect(instance.actions_for(action)).to_not be_nil
        end
      end
    end

    instance.actions.select{ |a| instance.playing_goes_onto_stack?(a) }.each do |action|
      context "defined stack action #{action}" do
        it "has a #actions_for_#{action} method" do
          expect(methods).to include("actions_for_#{action}")
        end
      end
    end

    instance.actions.reject{ |a| instance.playing_goes_onto_stack?(a) }.each do |action|
      context "defined non-stack action #{action}" do
        it "has a #actions_for_#{action} method" do
          expect(methods).to include("actions_for_#{action}")
        end
      end
    end
  end
end

