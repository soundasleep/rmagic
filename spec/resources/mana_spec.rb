require 'rails_helper'

RSpec.describe Mana, type: :resource do
  describe "#to_s" do
    it "formats mana costs of one green" do
      expect(Mana.new(green: 1).to_s).to eq("{g}")
    end

    it "formats mana costs of one green and one uncoloured" do
      expect(Mana.new(green: 1, colourless: 1).to_s).to eq("{1g}")
    end

    it "formats mana costs of one red and one green" do
      expect(Mana.new(red: 1, green: 1).to_s).to eq("{gr}")
    end

    it "formats mana costs of one red and one white" do
      expect(Mana.new(red: 1, white: 1).to_s).to eq("{rw}")
    end

    it "formats empty mana costs" do
      expect(Mana.new().to_s).to eq("{0}")
    end
  end

  describe "#converted_cost" do
    it "converts mana costs of one green" do
      expect(Mana.new(green: 1).converted_cost).to eq(1)
    end

    it "converts mana costs of one green and one uncoloured" do
      expect(Mana.new(green: 1, colourless: 1).converted_cost).to eq(2)
    end

    it "converts mana costs of one red and one green" do
      expect(Mana.new(red: 1, green: 1).converted_cost).to eq(2)
    end

    it "converts mana costs of one red and one white" do
      expect(Mana.new(red: 1, white: 1).converted_cost).to eq(2)
    end

    it "converts empty mana costs" do
      expect(Mana.new().converted_cost).to eq(0)
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

  describe "#empty?" do
    it "returns true for an empty pool" do
      expect(Mana.new()).to be_empty
    end

    it "returns false for a non-empty pool" do
      expect(Mana.new(green: 1)).to_not be_empty
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
