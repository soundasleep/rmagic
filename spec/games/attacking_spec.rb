require "game_helper"

RSpec.describe "Attacking", type: :game do
  let(:duel) { create_game }

  before :each do
    create_creatures

    duel.attacking_phase!
  end

  def our_creatures
    duel.player1.battlefield_creatures.map(&:card)
  end

  it "at the start of a duel, we have no declared attackers" do
    expect(duel.declared_attackers).to be_empty
  end

  it "we can declare three attackers on our turn" do
    expect(available_attackers.map(&:card)).to eq(our_creatures)
  end

  it "we can't declare any attackers when its not our turn" do
    duel.current_player_number = 2
    duel.save!

    available_attackers.map(&:card).each do |e|
      expect(our_creatures).to_not include(e)
    end
  end

  it "can be declared in a phase which can declare attackers" do
    expect(duel.phase.can_declare_attackers?).to be(true)
  end

  context "when declaring all attackers" do
    before :each do
      declare_attackers available_attackers
    end

    context "in the next turn" do
      before :each do
        pass_priority
      end

      it "we can declare two defenders (from player 2)" do
        defends = defendable_cards(duel.player2)

        expect(defends.to_a.uniq{ |d| d.source }.count).to eq(2)
      end

      context "defenders" do
        let(:defenders) { defendable_cards(duel.player2) }

        it "each have a source and target" do
          defenders.each do |d|
            expect(d.source).to_not be_nil
            expect(d.target).to_not be_nil
            expect(d.source.card).to_not be_nil
            expect(d.target.card).to_not be_nil
          end
        end

        it "each have a description" do
          defenders.each do |d|
            expect(d.description).to_not be_nil
          end
        end

        it "can each defend one attacker" do
          expect(defenders.count).to eq(2 * 3)
        end
      end
    end

    it "declared attackers are available through the duel" do
      expect(duel.declared_attackers.map(&:card)).to eq(available_attackers.map(&:card))
    end

    it "after declaring attackers, when we get to the next turn the attackers will be cleared" do
      expect( duel.declared_attackers ).to_not be_empty

      pass_until_next_turn

      expect(duel.declared_attackers).to be_empty
    end

    it "after declaring attackers, when we get to the next player the attackers will be cleared" do
      expect( duel.declared_attackers ).to_not be_empty

      pass_until_next_player

      expect(duel.declared_attackers).to be_empty
    end
  end

  context "when declaring one attacker" do
    let(:attacker) { available_attackers.first }

    before :each do
      expect(declaring_actions(attacker).count).to eq(0)
      expect(duel.declared_attackers.count).to eq(0)

      declare_attackers [attacker]
    end

    it "declaring an attacker creates an action" do
      expect(declaring_actions(attacker).count).to eq(1)
    end

    it "declared attackers do not persist into the next turn" do
      expect(duel.declared_attackers.count).to eq(1)

      pass_until_next_player
      expect(duel.declared_attackers.count).to eq(0)
    end

    it "a player can't defend when they're still attacking" do
      expect(defendable_cards(duel.player2)).to be_empty
      pass_priority

      # but the next player can
      expect( defendable_cards(duel.player2) ).not_to be_empty
    end

    it "if no defenders are declared, then attacks hit the player" do
      expect(duel.player2.life).to eq(20)
      pass_priority

      pass_until_next_turn

      expect(duel.player2.life).to eq(20 - attacker.card.card_type.power)
    end
  end

end
