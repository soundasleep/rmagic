require_relative "setup_game"

RSpec.describe "Defending Groups" do
  before :each do
    setup

    create_creatures

    @duel.attacking_phase!

    @card = available_attackers.first
    game_engine.declare_attackers [@card]

    game_engine.pass

    defends = game_engine.available_actions(@duel.player2)[:defend]
    game_engine.declare_defender defends.first
    defends = game_engine.available_actions(@duel.player2)[:defend]
    game_engine.declare_defender defends.first
  end

  it "we can defend with two defenders" do
    pass_until_next_turn

    expect(@duel.player2.life).to eq(20)
  end

  it "we can referenced the declared group defenders" do
    expect(@duel.declared_defenders.length).to eq(2)
  end

  it "overdefending will kill the single attacker" do
    pass_until_next_turn

    expect(@duel.player1.battlefield).to_not include(@card)
  end

  it "overdefending will put the attacker into the graveyard" do
    expect(@duel.player1.graveyard).to be_empty

    pass_until_next_turn

    expect(@duel.player1.graveyard).to_not be_empty
  end

  it "overdefending will create a graveyard action" do
    expect(graveyard_actions(@card.entity).count).to eq(0)

    pass_until_next_turn

    expect(graveyard_actions(@card.entity).count).to eq(1)
  end
end
