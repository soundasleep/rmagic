require_relative "setup_game"

RSpec.describe "Instants returning any graveyard", type: :game do
  let(:duel) { create_game }
  let(:card) { first_instant }

  before :each do
    create_graveyard_cards Library::Metaverse1.id
    create_graveyard_cards Library::Metaverse3.id
    create_hand_cards Library::InstantGraveyardAny.id
    duel.playing_phase!
  end

  def first_instant
    duel.player1.hand.select{ |b| b.card.card_type.actions.include?("instant") }.first
  end

  def instant_actions(zone_card)
    actions(zone_card.card, "instant")
  end

  def first_instant_available_actions
    available_play_actions("instant")
  end

  it "can be found" do
    expect(first_instant).to_not be_nil
  end

  it "can be played in a phase which can cast instants" do
    expect(duel.phase.can_instant?).to be(true)
  end

  context "without mana" do
    it "requires mana" do
      expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant"))).to be(false)
    end

    it "is not listed as an available action" do
      expect(first_instant_available_actions).to be_empty
    end
  end

  context "with mana" do
    let(:targets) { duel.player1.graveyard_creatures }

    before :each do
      tap_all_lands
    end

    context "can be played with mana" do
      it "and one target from our graveyard" do
        expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant", target: targets.first))).to be(true)
      end

      it "and another target from our graveyard" do
        expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant", target: targets.second))).to be(true)
      end

      it "but not with a target from their graveyard" do
        expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant", target: duel.player2.graveyard_creatures.first))).to be(false)
      end

      it "but not without a target" do
        expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "instant"))).to be(false)
      end
    end

    context "when activated" do
      before :each do
        expect(duel.player1.graveyard_creatures.length).to eq(2)
        expect(duel.player2.graveyard_creatures.length).to eq(2)
      end

      context "on our first creature" do
        before :each do
          game_engine.card_action(PossiblePlay.new(source: card, key: "instant", target: targets.first))
          pass_until_next_phase
        end

        it "removes our creature from the graveyard" do
          expect(duel.player1.graveyard_creatures).to eq([targets.second])
        end

        it "adds our creature into the battlefield" do
          expect(duel.player1.battlefield_creatures.map{|b| b.card}).to eq([targets.first.card])
        end
      end

      context "on our second creature" do
        before :each do
          game_engine.card_action(PossiblePlay.new(source: card, key: "instant", target: targets.second))
          pass_until_next_phase
        end

        it "removes our creature from the graveyard" do
          expect(duel.player1.graveyard_creatures).to eq([targets.first])
        end

        it "adds our creature into the battlefield" do
          expect(duel.player1.battlefield_creatures.map{|b| b.card}).to eq([targets.second.card])
        end
      end

    end
  end

end
