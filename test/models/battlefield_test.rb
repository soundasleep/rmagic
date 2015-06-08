require 'test_helper'

class BattlefieldTest < ActiveSupport::TestCase
  test "we can't reference the same entity twice in the battlefield" do
    e = Entity.create!
    p = Player.create!

    b1 = Battlefield.create({ player: p, entity: e })
    assert b1.valid?

    b2 = Battlefield.create({ player: p, entity: e })
    assert !b2.valid?
  end
end
