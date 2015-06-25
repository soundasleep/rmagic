require_relative "setup_game"

RSpec.describe "Instants destroy" do
  let(:duel) { create_game }
  let(:card) { first_destroy }

  before :each do
    create_battlefield_cards Library::Metaverse1.id
    create_hand_cards Library::Metaverse5.id
    duel.playing_phase!
  end

  def first_destroy
    duel.player1.hand.select{ |b| b.card.card_type.actions.include?("destroy") }.first
  end

  def destroy_actions(zone_card)
    actions(zone_card.card, "destroy")
  end

  def first_destroy_available_actions
    available_play_actions("destroy")
  end

  it "can be created manually" do
    expect(first_destroy).to_not be_nil
  end

  it "can be played in a phase which can cast destroys" do
    expect(duel.phase.can_instant?).to be(true)
  end

  context "without mana" do
    it "requires mana" do
      expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "destroy"))).to be(false)
    end

    it "is not listed as an available action" do
      expect(first_destroy_available_actions).to be_empty
    end
  end

  context "with mana" do
    before :each do
      tap_all_lands
    end

    context "can be played with mana" do
      it "and a target" do
        expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "destroy", target: duel.player1.battlefield_creatures.first))).to be(true)
      end

      it "but not without a target" do
        expect(game_engine.can_do_action?(PossiblePlay.new(source: card, key: "destroy"))).to be(false)
      end
    end

    context "is listed as an available action" do
      it "of one type" do
        expect(first_destroy_available_actions.to_a.uniq{ |u| u.source }.length).to eq(1)
      end

      it "of two targets" do
        expect(first_destroy_available_actions.length).to eq(2)
      end

      it "with the correct source and key" do
        available_actions[:play].each do |a|
          expect(a.source).to eq(card)
          expect(a.key).to eq("destroy")
        end
      end
    end

    it "all actions have source and key and target specified" do
      available_actions[:play].each do |a|
        expect(a.source).to_not be_nil
        expect(a.key).to_not be_nil
        expect(a.target).to_not be_nil
      end
    end

    it "all actions have a description" do
      available_actions[:play].each do |a|
        expect(a.description).to_not be_nil
      end
    end

    context "when activated" do
      before :each do
        expect(duel.player1.battlefield_creatures.length).to eq(1)
        expect(duel.player2.battlefield_creatures.length).to eq(1)
      end

      context "on our creature" do
        before :each do
          game_engine.card_action(PossiblePlay.new(source: card, key: "destroy", target: duel.player1.battlefield_creatures.first))
        end

        it "removes our creature" do
          expect(duel.player1.battlefield_creatures).to be_empty
        end

        it "does not remove their creature" do
          expect(duel.player2.battlefield_creatures).to_not be_empty
        end

        it "creates an action" do
          expect(destroy_actions(card).map{ |card| card.card }).to eq([card.card])
        end

        it "consumes mana" do
          expect(duel.player1.mana_green).to eq(2)
        end
      end

      context "on their creature" do
        before :each do
          game_engine.card_action(PossiblePlay.new(source: card, key: "destroy", target: duel.player2.battlefield_creatures.first))
        end

        it "removes their creature" do
          expect(duel.player2.battlefield_creatures).to be_empty
        end

        it "does not remove our creature" do
          expect(duel.player1.battlefield_creatures).to_not be_empty
        end

        it "creates an action" do
          expect(destroy_actions(card).map{ |card| card.card }).to eq([card.card])
        end

        it "consumes mana" do
          expect(duel.player1.mana_green).to eq(2)
        end
      end

    end
  end

end
