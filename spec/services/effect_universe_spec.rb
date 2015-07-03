require 'rails_helper'

RSpec.describe EffectUniverse, type: :service do
  let(:service) { EffectUniverse.new }

  context "#find_effect" do
    context "metaverse 1" do
      let(:card) { service.find_effect(1) }

      it "exists" do
        expect(card).to_not be(false)
      end

      it "has ID 1" do
        expect(card.effect_id).to eq(1)
      end
    end

    context "metaverse -1" do
      let(:card) { service.find_effect(-1) }

      it "doesn't exist" do
        expect(card).to be(false)
      end
    end
  end

  context "#all" do
    let(:all) { service.all }

    it "provides effects" do
      expect(all).to_not be_empty
    end

    it "provides at least one effect" do
      expect(all.count).to be > 0
    end

    context "each effect" do
      it "has an effect id" do
        all.each do |effect|
          expect(effect.effect_id).to_not be_nil
        end
      end
    end
  end
end
