require_relative "setup_game"

RSpec.describe "Defending" do
  before :each do
    setup

    create_creatures

    @duel.attacking_phase!

    @card = available_attackers.first
    game_engine.declare_attackers [@card]

    game_engine.pass
  end

  it "can be declared in a phase which can declare defenders" do
    expect(@duel.phase.can_declare_defenders?).to eq(true)
  end

  it "each defender can defend one attacker if only one attacks" do
    defends = game_engine.available_actions(@duel.player2)[:defend]

    expect(defends.count).to eq(2)
  end

  it "an attacker stores which player is attacking" do
    expect(@duel.declared_attackers.first.player).to eq(@duel.player1)
  end

  it "an attacker stores which player its attacking" do
    expect(@duel.declared_attackers.first.target_player).to eq(@duel.player2)
  end

  it "a declared defender does not come up as another available defend option" do
    defends = game_engine.available_actions(@duel.player2)[:defend]
    defender = defends.first
    game_engine.declare_defender defender

    game_engine.available_actions(@duel.player2)[:defend].each do |defend|
      expect(defend[:target]).to_not eq(defend[:source])
    end
  end

  it "a defender can be declared and blocks damage" do
    defends = game_engine.available_actions(@duel.player2)[:defend]

    game_engine.declare_defender defends.first

    pass_until_next_turn

    expect(@duel.player2.life).to eq(20)
  end

  it "a declared defender creates an action" do
    defends = game_engine.available_actions(@duel.player2)[:defend]
    card = defends.first

    expect(defending_actions(card[:source]).count).to eq(0)

    game_engine.declare_defender card
    expect(defending_actions(card[:source]).count).to eq(1)
  end

  it "a defender can be declared and referenced later" do
    defends = game_engine.available_actions(@duel.player2)[:defend]

    expect(@duel.declared_defenders.count).to eq(0)
    game_engine.declare_defender defends.first
    expect(@duel.declared_defenders.count).to eq(1)
  end

  it "declared defenders do not persist into the next turn" do
    defends = game_engine.available_actions(@duel.player2)[:defend]

    expect(@duel.declared_defenders.count).to eq(0)
    game_engine.declare_defender defends.first
    expect(@duel.declared_defenders.count).to eq(1)

    pass_until_next_player
    expect(@duel.declared_defenders.count).to eq(0)
  end

  context "when declaring defenders" do
    before :each do
      defends = game_engine.available_actions(@duel.player2)[:defend]
      game_engine.declare_defender defends.first

      @defender = defends.first[:source]
      @attacker = defends.first[:target]
    end

    it "attacking actions are created when there are defenders and the attack resolves" do
      expect(attacking_actions(@card).count).to eq(0)

      pass_until_next_turn

      assert_equal 1, attacking_actions(@card).count
    end

    it "attacking actions references the attacked defender" do
      expect(attacking_actions(@card).count).to eq(0)

      pass_until_next_turn

      action = attacking_actions(@card).first
      expect(action.targets.first.entity).to eq(@defender.entity)
    end

    it "attacking actions include a reference to defending creatures after the attack resolves" do
      pass_until_next_turn

      action = attacking_actions(@card).first
      expect(action.entity).to eq(@attacker.entity)
    end

    it "defending actions are created when there are defenders and the attack resolves" do
      expect(defended_actions(@defender).count).to eq(0)

      pass_until_next_turn

      expect(defended_actions(@defender).count).to eq(1)
    end

    it "defending actions reference the defended attacker" do
      pass_until_next_turn

      expect(defended_actions(@defender).first.targets.map{ |t| t.entity }).to include(@card.entity)
    end
  end

  it "attacking actions are created when there are no defenders and the attack resolves" do
    expect(attacking_actions(@card).count).to eq(0)

    pass_until_next_turn

    expect(attacking_actions(@card).count).to eq(1)
  end

end
