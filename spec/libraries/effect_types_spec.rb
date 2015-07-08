require 'rails_helper'

Library.new.effect_types.each do |id, effect_type|
  RSpec.describe effect_type, type: :library do
    instance = effect_type.new

    it "has an effect id" do
      expect(instance.effect_id).to_not be_nil
    end

    it "hads a class effect id equal to effect id" do
      expect(instance.effect_id).to eq(instance.class.effect_id)
    end

    it "has a description" do
      expect(instance.to_text).to_not be_nil
    end
  end
end

