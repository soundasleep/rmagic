require "game_helper"

RSpec.describe "Defending Groups", type: :game do
  let(:duel) { create_game }
  let(:attacker) { available_attackers.first }

  before :each do
    create_creatures

    duel.attacking_phase!

    declare_attackers [attacker]

    pass_priority

    defends = action_finder.defendable_cards(duel.player2)
    defends.first.declare duel
    defends = action_finder.defendable_cards(duel.player2)
    defends.first.declare duel
  end

  it "we can defend with two defenders" do
    pass_until_next_turn

    expect(duel.player2.life).to eq(20)
  end

  it "we can referenced the declared group defenders" do
    expect(duel.declared_defenders.length).to eq(2)
  end

  it "overdefending will kill the single attacker" do
    pass_until_next_turn

    expect(duel.player1.battlefield).to_not include(attacker)
  end

  it "overdefending will put the attacker onto the graveyard" do
    expect(duel.player1.graveyard).to be_empty

    pass_until_next_turn

    expect(duel.player1.graveyard).to_not be_empty
  end

  it "overdefending will create a graveyard action" do
    expect(graveyard_actions(attacker.card).count).to eq(0)

    pass_until_next_turn

    expect(graveyard_actions(attacker.card).count).to eq(1)
  end
end