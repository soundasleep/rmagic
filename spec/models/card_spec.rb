RSpec.describe Card do
  it "needs a metaverse id" do
    e = Card.create()
    assert !e.valid?
  end

  it "needs a metaverse id that exists" do
    e = Card.create(metaverse_id: 0)
    assert !e.valid?
  end
end
