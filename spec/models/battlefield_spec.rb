require 'rails_helper'

RSpec.describe Battlefield, type: :model do
  it "can't reference the same card twice" do
    e = Card.create!(metaverse_id: 1, turn_played: 0)
    p = Player.create!()

    b1 = Battlefield.create({ player: p, card: e })
    expect(b1.valid?).to be(true)

    b2 = Battlefield.create({ player: p, card: e })
    expect(b2.valid?).to be(false)
  end
end
