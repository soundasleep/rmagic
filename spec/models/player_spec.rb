RSpec.describe Player do
  include ManaHelper

  it "a player can have a mana pool" do
    player = Player.create!( mana_green: 1 )
    expect(player.mana_pool).to eq( green: 1, blue: 0, red: 0, white: 0, black: 0, colourless: 0 )
  end

  it "we can use green mana to pay for green mana" do
    player = Player.create!( mana_green: 1 )
    expect(player.has_mana?( green: 1 )).to be(true)

    player.use_mana!( green: 1 )
    expect(player.mana_green).to eq(0)
  end

  it "we can use green mana to pay for dual mana" do
    player = Player.create!( mana_green: 2 )
    expect(player.has_mana?( green: 1, colourless: 1 )).to be(true)

    player.use_mana!( green: 1, colourless: 1 )
    expect(player.mana_green).to eq(0)
  end

  it "we can use partial mana pools" do
    player = Player.create!( mana_green: 2 )
    expect(player.has_mana?( green: 1 )).to be(true)

    player.use_mana!( green: 1 )
    expect(player.mana_green).to eq(1)
  end

  it "we can't use red mana to pay for green mana" do
    player = Player.create!( mana_red: 1 )
    expect(player.has_mana?( green: 1 )).to be(false)
  end

  it "we can use green mana to pay for colourless mana" do
    player = Player.create!( mana_green: 1 )
    expect(player.has_mana?( colourless: 1 )).to be(true)

    player.use_mana!( green: 1 )
    expect(player.mana_green).to eq(0)
  end

  it "we have to have the right amount of mana for colourless mana" do
    player = Player.create!( mana_green: 1, mana_blue: 2 )
    expect(player.has_mana?(colourless: 2, green: 1 )).to be(true)
    expect(player.has_mana?( colourless: 3, green: 1 )).to be(false)
    expect(player.has_mana?( colourless: 2, green: 1, blue: 1 )).to be(false)
  end

  it "we can use coloured mana to pay for colourless mana combos" do
    player = Player.create!( mana_green: 1, mana_blue: 2 )
    expect(player.has_mana?( colourless: 2, green: 1 )).to be(true)

    player.use_mana!( colourless: 2, green: 1 )
    expect(player.mana_green).to eq(0)
    expect(player.mana_blue).to eq(0)
  end

  it "we can use colourless mana to pay for colourless mana" do
    player = Player.create!( mana_colourless: 2 )
    expect(player.has_mana?(colourless: 1)).to be(true)

    player.use_mana!( colourless: 1 )
    expect(player.mana_colourless).to eq(1)
  end

  context "a new player" do
    before :each do
      @player = Player.create!
    end

    it "has no mana" do
      expect(@player.mana_pool).to eq(zero_mana)
    end

    it "has 20 life" do
      expect(@player.life).to eq(20)
    end

    it "can add life" do
      @player.add_life! 1
      expect(@player.life).to eq(20 + 1)
    end

    it "can remove life" do
      @player.remove_life! 1
      expect(@player.life).to eq(20 - 1)
    end

    context "adding green mana" do
      before :each do
        @player.add_mana! green: 1
      end

      it "can provide green mana" do
        expect(@player.has_mana?(green: 1)).to be(true)
      end

      it "can provide colourless mana" do
        expect(@player.has_mana?(colourless: 1)).to be(true)
      end

      it "does not provide red mana" do
        expect(@player.has_mana?(red: 1)).to be(false)
      end

      context "twice" do
        before :each do
          @player.add_mana! green: 1
        end

        it "provides two mana" do
          expect(@player.has_mana?(green: 2)).to be(true)
        end
      end
    end
  end

end
