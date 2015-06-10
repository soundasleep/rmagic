RSpec.describe Player do
  it "a player can have a mana pool" do
    player = Player.create!({ mana_green: 1 })
    assert_equal ({ green: 1, blue: 0, red: 0, white: 0, black: 0, colourless: 0 }), player.mana_pool
  end

  it "we can use green mana to pay for green mana" do
    player = Player.create!({ mana_green: 1 })
    assert player.has_mana? ({ green: 1 })

    player.use_mana ({ green: 1 })
    assert_equal 0, player.mana_green
  end

  it "we can use green mana to pay for dual mana" do
    player = Player.create!({ mana_green: 2 })
    assert player.has_mana? ({ green: 1, colourless: 1 })

    player.use_mana ({ green: 1, colourless: 1 })
    assert_equal 0, player.mana_green
  end

  it "we can use partial mana pools" do
    player = Player.create!({ mana_green: 2 })
    assert player.has_mana? ({ green: 1 })

    player.use_mana ({ green: 1 })
    assert_equal 1, player.mana_green
  end

  it "we can't use red mana to pay for green mana" do
    player = Player.create!({ mana_red: 1 })
    assert !player.has_mana?({ green: 1 })
  end

  it "we can use green mana to pay for colourless mana" do
    player = Player.create!({ mana_green: 1 })
    assert player.has_mana? ({ colourless: 1 })

    player.use_mana ({ green: 1 })
    assert_equal 0, player.mana_green
  end

  it "we have to have the right amount of mana for colourless mana" do
    player = Player.create!({ mana_green: 1, mana_blue: 2 })
    assert player.has_mana?({ colourless: 2, green: 1 })
    assert !player.has_mana?({ colourless: 3, green: 1 })
    assert !player.has_mana?({ colourless: 2, green: 1, blue: 1 })
  end

  it "we can use coloured mana to pay for colourless mana combos" do
    player = Player.create!({ mana_green: 1, mana_blue: 2 })
    assert player.has_mana? ({ colourless: 2, green: 1 })

    player.use_mana ({ colourless: 2, green: 1 })
    assert_equal 0, player.mana_green
    assert_equal 0, player.mana_blue
  end

  it "we can use colourless mana to pay for colourless mana" do
    player = Player.create!({ mana_colourless: 2 })
    assert player.has_mana?({ colourless: 1 }), player.mana

    player.use_mana ({ colourless: 1 })
    assert_equal 1, player.mana_colourless
  end

end
