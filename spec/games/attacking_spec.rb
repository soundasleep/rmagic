require_relative "game_test"

RSpec.describe "Attacking" do
  before :each do
    setup

    create_creatures

    @duel.phase_number = Duel.attacking_phase
    @duel.save!
  end

  it "at the start of a duel, we have no declared attackers" do
    expect(@duel.declared_attackers).to be_empty
  end

  it "we can declare three attackers on our turn" do
    expect(available_attackers.map{ |b| b.entity }).to eq(our_creatures)
  end

  it "we can't declare any attackers when its not our turn" do
    @duel.current_player_number = 2
    @duel.save!

    available_attackers.map{ |b| b.entity }.each do |e|
      expect(our_creatures).to_not include(e)
    end
  end

  it "after we declare three attackers, we can declare two defenders (from player 2)" do
    game_engine.declare_attackers available_attackers
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    expect(defends.to_a.uniq{ |d| d[:source] }.count).to eq(2)
  end

  it "defenders have an entity and a target" do
    game_engine.declare_attackers available_attackers
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]
    defends.each do |d|
      expect(d[:source]).to_not be_nil, "#{d} had no :source"
      expect(d[:target]).to_not be_nil, "#{d} had no :target"
      expect(d[:source].entity).to_not be_nil, "#{d} had no :source.entity"
      expect(d[:target].entity).to_not be_nil, "#{d} had no :target.entity"
    end
  end

  it "each defender can defend one attacker" do
    game_engine.declare_attackers available_attackers
    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]

    expect(defends.count).to eq(2 * 3)
  end

  it "declared attackers are available through the duel" do
    game_engine.declare_attackers available_attackers
    expect(@duel.declared_attackers.map{ |a| a.entity }).to eq(available_attackers.map{ |a| a.entity })
  end

  it "after declaring attackers, when we get to the next turn the attackers will be cleared" do
    game_engine.declare_attackers available_attackers
    expect( @duel.declared_attackers ).to_not be_empty

    pass_until_next_turn

    expect(@duel.declared_attackers).to be_empty
  end

  it "after declaring attackers, when we get to the next player the attackers will be cleared" do
    game_engine.declare_attackers available_attackers
    expect( @duel.declared_attackers ).to_not be_empty

    pass_until_next_player

    expect(@duel.declared_attackers).to be_empty
  end

  it "declaring an attacker creates an action" do
    card = available_attackers.first
    expect(declaring_actions(card).count).to eq(0)

    game_engine.declare_attackers [card]

    expect(declaring_actions(card).count).to eq(1)
  end

  it "declared attackers do not persist into the next turn" do
    card = available_attackers.first
    expect(@duel.declared_attackers.count).to eq(0)

    game_engine.declare_attackers [card]

    expect(@duel.declared_attackers.count).to eq(1)

    pass_until_next_player
    expect(@duel.declared_attackers.count).to eq(0)
  end

  it "a player can't defend when they're still attacking" do
    card = available_attackers.first
    game_engine.declare_attackers [card]

    expect(game_engine.available_actions(@duel.player2)[:defend]).to be_empty
    game_engine.pass

    # but the next player can
    expect( game_engine.available_actions(@duel.player2)[:defend] ).not_to be_empty
  end

  it "if no defenders are declared, then attacks hit the player" do
    card = available_attackers.first
    game_engine.declare_attackers [card]

    expect(@duel.player2.life).to eq(20)
    game_engine.pass

    pass_until_next_turn

    expect(@duel.player2.life).to eq(20 - card.entity.find_card!.power)
  end

end
