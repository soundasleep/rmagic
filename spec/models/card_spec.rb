RSpec.describe Card do
  it "needs a metaverse id" do
    e = Card.create()
    expect(e.valid?).to eq(false)
  end

  it "needs a metaverse id that exists" do
    e = Card.create(metaverse_id: 0)
    expect(e.valid?).to eq(false)
  end
end
