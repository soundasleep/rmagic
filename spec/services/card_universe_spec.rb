require 'rails_helper'

RSpec.describe CardUniverse, type: :service do
  let(:service) { CardUniverse.new }

  context "#find_metaverse" do
    context "metaverse 1" do
      let(:card) { service.find_metaverse(Library::Metaverse1.id) }

      it "exists" do
        expect(card).to_not be(false)
      end

      it "has ID 1" do
        expect(card.metaverse_id).to eq(Library::Metaverse1.id)
      end
    end

    context "metaverse -1" do
      let(:card) { service.find_metaverse(-1) }

      it "doesn't exist" do
        expect(card).to be(false)
      end
    end
  end

  context "#all" do
    let(:all) { service.all }

    it "provides cards" do
      expect(all).to_not be_empty
    end

    it "provides at least one card" do
      expect(all.count).to be > 0
    end
  end
end
