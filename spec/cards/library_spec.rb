require 'rails_helper'

RSpec.describe Library do
  let(:library) { Library.new }
  let(:card_types) { library.card_types }

  it "has a list of card types" do
    expect(card_types).to_not be_empty
  end

  context "card types" do
    it "each have a metaverse id" do
      card_types.each do |id, card_type|
        expect(card_type.metaverse_id).to_not be_nil
      end
    end

    it "each have a description" do
      card_types.each do |id, card_type|
        expect(card_type.to_text).to_not be_nil
      end
    end
  end
end
