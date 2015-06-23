RSpec.describe Battlefield do
  it "can't reference the same card twice" do
    e = Card.create!(metaverse_id: 1, turn_played: 0)
    p = Player.create!()

    b1 = Battlefield.create({ player: p, card: e })
    assert b1.valid?

    b2 = Battlefield.create({ player: p, card: e })
    assert !b2.valid?
  end
end
