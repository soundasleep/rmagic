require "game_helper"

RSpec.describe "Instants returning any graveyard", type: :game do
  let(:duel) { create_game }
  let(:card) { first_instant }

  before :each do
    create_graveyard_cards Library::Metaverse1
    create_graveyard_cards Library::Metaverse3
    create_hand_cards Library::InstantGraveyardAny
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
    let(:play) { PlayAction.new(source: card, key: "instant") }

    it "requires mana" do
      expect(play.can_do?(duel)).to be(false)
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

    context "with one target from our graveyard" do
      let(:play) { PlayAction.new(source: card, key: "instant", target: targets.first) }

      it "can be played" do
        expect(play.can_do?(duel)).to be(true)
      end
    end

    context "with another target from our graveyard" do
      let(:play) { PlayAction.new(source: card, key: "instant", target: targets.second) }

      it "can be played" do
        expect(play.can_do?(duel)).to be(true)
      end
    end

    context "with a target from their graveyard" do
      let(:play) { PlayAction.new(source: card, key: "instant", target: duel.player2.graveyard_creatures.first) }

      it "can not be played" do
        expect(play.can_do?(duel)).to be(false)
      end
    end

    context "without a target" do
      let(:play) { PlayAction.new(source: card, key: "instant") }

      it "can not be played" do
        expect(play.can_do?(duel)).to be(false)
      end
    end

    context "when activated" do
      before :each do
        expect(duel.player1.graveyard_creatures.length).to eq(2)
        expect(duel.player2.graveyard_creatures.length).to eq(2)
      end

      context "on our first creature" do
        before :each do
          PlayAction.new(source: card, key: "instant", target: targets.first).do duel
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
          PlayAction.new(source: card, key: "instant", target: targets.second).do duel
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
