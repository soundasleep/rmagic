require 'rails_helper'

RSpec.describe Card, type: :model do
  it "needs a metaverse id" do
    e = Card.create()
    expect(e.valid?).to be(false)
  end

  it "needs a metaverse id that exists" do
    e = Card.create(metaverse_id: 0)
    expect(e.valid?).to be(false)
  end
end
