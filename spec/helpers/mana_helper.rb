RSpec.describe ManaHelper do
  include ManaHelper

  it "formats mana costs of one green" do
    expect(mana_cost_string(zero_mana.merge(green: 1))).to eq("{g}")
  end

  it "formats mana costs of one green and one uncoloured" do
    expect(mana_cost_string(zero_mana.merge(colourless: 1, green: 1))).to eq("{1g}")
  end

  it "formats empty mana costs" do
    expect(mana_cost_string(zero_mana)).to eq("{0}")
  end

end
