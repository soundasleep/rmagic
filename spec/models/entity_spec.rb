RSpec.describe Entity do
  it "needs a metaverse id" do
    e = Entity.create()
    assert !e.valid?
  end

  it "needs a metaverse id that exists" do
    e = Entity.create(metaverse_id: 0)
    assert !e.valid?
  end
end
