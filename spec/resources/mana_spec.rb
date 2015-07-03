require 'rails_helper'

RSpec.describe Mana, type: :resource do
  describe "#to_s" do
    it "formats mana costs of one green" do
      expect(Mana.new(green: 1).to_s).to eq("{g}")
    end

    it "formats mana costs of one green and one uncoloured" do
      expect(Mana.new(green: 1, colourless: 1).to_s).to eq("{1g}")
    end

    it "formats empty mana costs" do
      expect(Mana.new().to_s).to eq("{0}")
    end
  end

  describe "#to_hash" do
    it "formats mana costs of one green" do
      expect(Mana.new(green: 1).to_hash).to eq({
        green: 1,
        blue: 0,
        red: 0,
        white: 0,
        black: 0,
        colourless: 0
      })
    end
  end

  describe "#==" do
    it "equals two identical objects" do
      o = Mana.new(green: 1)
      expect(o).to eq(o)
    end

    it "equals two equal objects" do
      expect(Mana.new(green: 1)).to eq(Mana.new(green: 1))
    end

    it "does not equal two different objects" do
      expect(Mana.new(green: 1)).to_not eq(Mana.new(colourless: 1))
    end
  end
end
