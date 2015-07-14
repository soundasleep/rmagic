require "game_helper"

RSpec.describe "Instants returning the top of graveyard", type: :game do
  let(:duel) { create_game }
  let(:card) { first_instant }

  before :each do
    create_graveyard_cards Library::Metaverse1
    create_hand_cards Library::InstantGraveyardTop
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

      it "can not be played" do
        expect(play.can_do?(duel)).to be(false)
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

    context "is listed as an available action" do
      it "of one type" do
        expect(first_instant_available_actions.to_a.uniq{ |u| u.source }.length).to eq(1)
      end

      it "of one target" do
        expect(first_instant_available_actions.length).to eq(1)
      end

      it "with the correct source and key" do
        playable_cards(duel.player1).each do |a|
          expect(a.source).to eq(card)
          expect(a.key).to eq("instant")
        end
      end

      it "with only our targets" do
        playable_cards(duel.player1).each do |a|
          expect(a.target.player).to eq(duel.player1)
        end
      end
    end

    it "all actions have source and key and target specified" do
      playable_cards(duel.player1).each do |a|
        expect(a.source).to_not be_nil
        expect(a.key).to_not be_nil
        expect(a.target).to_not be_nil
      end
    end

    it "all actions have a description" do
      playable_cards(duel.player1).each do |a|
        expect(a.description).to_not be_nil
      end
    end

    context "when activated" do
      before :each do
        expect(duel.player1.graveyard_creatures.length).to eq(1)
        expect(duel.player2.graveyard_creatures.length).to eq(1)
      end

      let(:target) { duel.player1.graveyard_creatures.last }

      context "on our creature" do
        before :each do
          PlayAction.new(source: card, key: "instant", target: target).do duel
          pass_until_next_phase
        end

        it "removes our creature from the graveyard" do
          expect(duel.player1.graveyard_creatures).to be_empty
        end

        it "adds a creature into the battlefield" do
          expect(duel.player1.battlefield_creatures).to_not be_empty
        end

        it "adds our creature into the battlefield" do
          expect(duel.player1.battlefield_creatures.map{|b| b.card}).to eq([target.card])
        end

        it "creates an action" do
          expect(instant_actions(card).map{ |card| card.card }).to eq([card.card])
        end
      end
    end
  end

  context "with another creature in the graveyard" do
    before :each do
      create_graveyard_cards Library::Metaverse3
    end

    context "graveyard cards" do
      let(:order) { duel.player1.graveyard.map(&:order) }
      let(:uniques) { order.uniq }
      let(:order_classes) { duel.player1.graveyard.map(&:card).map(&:card_type).map(&:class) }

      it "each have a unique order" do
        expect(order).to eq(uniques)
      end

      it "are in increasing order based on time added" do
        expect(order_classes).to eq([ Library::Metaverse1, Library::Metaverse3 ])
      end
    end

    context "with mana" do
      let(:target) { duel.player1.graveyard_creatures.last }

      before :each do
        tap_all_lands
      end

      context "can be played with mana" do
        let(:play) { PlayAction.new(source: card, key: "instant", target: target) }

        it "and a target from our graveyard" do
          expect(play.can_do?(duel)).to be(true)
        end
      end

      context "is listed as an available action" do
        it "of one target" do
          expect(first_instant_available_actions.length).to eq(1)
        end

        it "with the correct source and key" do
          playable_cards(duel.player1).each do |a|
            expect(a.source).to eq(card)
            expect(a.key).to eq("instant")
          end
        end

        it "with only our target" do
          expect(playable_cards(duel.player1).first.target).to eq(target)
        end
      end
    end
  end

  context "with a land in the graveyard" do
    before :each do
      create_graveyard_cards Library::Forest
    end

    context "with mana" do
      let(:target) { duel.player1.graveyard_creatures.first }

      before :each do
        tap_all_lands
      end

      context "can be played with mana" do
        let(:play) { PlayAction.new(source: card, key: "instant", target: target) }

        it "and a target from our graveyard" do
          expect(play.can_do?(duel)).to be(true)
        end
      end

      context "is listed as an available action" do
        it "of one target" do
          expect(first_instant_available_actions.length).to eq(1)
        end

        it "with only our target" do
          expect(playable_cards(duel.player1).first.target).to eq(target)
        end
      end
    end
  end

end
