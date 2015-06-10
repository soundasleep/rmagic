require 'spec_helper'

RSpec.describe Battlefield do
  it "can't reference the same entity twice" do
    e = Entity.create!
    p = Player.create!

    b1 = Battlefield.create({ player: p, entity: e })
    assert b1.valid?

    b2 = Battlefield.create({ player: p, entity: e })
    assert !b2.valid?
  end
end

