RSpec.describe Battlefield do
  it "can't reference the same card twice" do
    e = Card.create!(metaverse_id: 1, turn_played: 0)
    p = Player.create!()

    b1 = Battlefield.create({ player: p, card: e })
    expect(b1.valid?).to eq(true)

    b2 = Battlefield.create({ player: p, card: e })
    expect(b2.valid?).to eq(false)
  end
end
