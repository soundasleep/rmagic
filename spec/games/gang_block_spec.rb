require "game_helper"

RSpec.describe "Gang Block", type: :game do
  let(:duel) { create_game }
  let(:card) { player1.battlefield_creatures.first }
  let(:attacker) { available_attackers.first }
  let(:defenders) { action_finder.defendable_cards(player2) }

  before :each do
    create_card player1.battlefield, Library::BasicCreature
    3.times { create_card player2.battlefield, Library::ElvishMystic }

    duel.attacking_phase!

    declare_attackers [attacker]

    pass_priority

    defenders.each do |defender| 
      defender.declare duel
    end
  end

  it "we can defend with three defenders" do
    pass_until_next_turn

    expect(duel.player2.life).to eq(20)
  end

  it "we can reference the declared group defenders" do
    expect(duel.declared_defenders.length).to eq(3)
  end

  it "overdefending will kill the single attacker" do
    pass_until_next_turn

    expect(duel.player1.battlefield).to_not include(attacker)
  end

  it "overdefending will kill the first 2 defenders" do
    p "before pass"
    p "first defender source: #{defenders[0].source.card.damage}"
    p "second defender source: #{defenders[1].source.card.damage}"
    p "third defender source: #{defenders[2].source.card.damage}"

    pass_until_next_turn
    p "after pass"
    # p "defenders: #{defenders}"
    p "attacker power: #{attacker.card.power}"
    p "first defender source: #{defenders[0].source.card.damage}"
    p "second defender source: #{defenders[1].source.card.damage}"
    p "third defender source: #{defenders[2].source.card.damage}"
    # p "battlefield: #{duel.player2.battlefield}"
    
    expect(duel.player2.battlefield).to_not include(defenders[0].source)
    expect(duel.player2.battlefield).to_not include(defenders[1].source)
    expect(duel.player2.battlefield).to include(defenders[2].source)
  end

  it "overdefending will put the attacker into the graveyard" do
    expect(duel.player1.graveyard).to be_empty

    pass_until_next_turn

    expect(duel.player1.graveyard).to_not be_empty
  end

  it "overdefending will put the first 2 defenders into the graveyard" do
    expect(duel.player2.graveyard).to be_empty

    pass_until_next_turn

    expect(duel.player2.graveyard.length).to eq 2
  end

  it "overdefending will create a graveyard action" do
    expect(graveyard_actions(attacker.card).count).to eq(0)

    pass_until_next_turn

    expect(graveyard_actions(attacker.card).count).to eq(1)
  end
end
