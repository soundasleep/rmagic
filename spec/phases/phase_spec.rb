require 'rails_helper'

RSpec.describe Phase, type: :phase do
  describe "#==" do
    it "returns true for two identical objects" do
      phase = PlayingPhase.new
      expect(phase).to eq(phase)
    end

    it "returns true for two of the same phases" do
      expect(PlayingPhase.new).to eq(PlayingPhase.new)
    end

    it "returns false for two different phases" do
      expect(PlayingPhase.new).to_not eq(DrawingPhase.new)
    end
  end
end
