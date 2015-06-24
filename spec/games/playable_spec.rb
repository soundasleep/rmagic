require_relative "setup_game"

RSpec.describe "Playable" do
  let(:duel) { create_game }

  before :each do
    duel.playing_phase!

    expect(duel.player1.hand).to be_empty

    creature = Card.create!( metaverse_id: 1, turn_played: 0 )
    duel.player1.hand.create! card: creature
  end

  def hand
    duel.player1.hand
  end

  def battlefield_creatures
    duel.player1.battlefield_creatures.map{ |b| b.card }
  end

  it "we can set and compare phase directly" do
    duel.reload
    expect(duel.playing_phase?).to eq(true)
    expect(duel.phase_number).to eq("playing_phase")
  end

  it "can be played in a phase which can cast instants" do
    expect(duel.phase.can_play?).to eq(true)
  end

  it "we cannot compare phase with symbols" do
    duel.reload
    expect(duel.phase_number).to_not eq(:playing_phase)
  end

  it "without tapping, we can't play anything" do
    expect(available_actions[:play]).to be_empty
  end

  context "tapping all lands on our turn" do
    before :each do
      tap_all_lands
    end

    it "provides three green mana" do
      expect(duel.player1.mana_green).to eq(3)
    end

    it "we have a creature to play" do
      expect(duel.player1.hand.select{ |h| h.card.metaverse_id == 1 }.length).to eq(1)
    end

    it "allows us to play a creature" do
      expect(available_actions[:play].map { |h| h.source.card }).to eq([hand.first!.card])
    end

    it "allows us to play a creature with the play action" do
      expect(available_actions[:play].map { |h| h.key }).to eq(["play"])
    end

    context "playing a creature" do
      before :each do
        expect(battlefield_creatures).to be_empty

        @card = hand.first!
        game_engine.card_action PossiblePlay.new(source: @card, key: "play")
      end

      it "creates an action" do
        expect(actions(@card.card, "play").map{ |c| c.card }).to eq([ @card.card ])
      end

      it "puts a creature on the battlefield" do
        expect(battlefield_creatures).to eq([@card.card])
      end

      it "we're on turn 1" do
        expect(duel.turn).to eq(1)
      end

      it "stores when the card was played" do
        expect(battlefield_creatures.first.turn_played).to eq(1)
      end

      context "gives it summoning sickness" do
        it "and it cannot attack in the current turn" do
          duel.attacking_phase!

          expect(available_attackers).to eq([])
        end

        it "but can attack in the next turn" do
          pass_until_next_turn

          duel.attacking_phase!
          expect(available_attackers.map{ |b| b.card }).to eq([@card.card])
        end
      end
    end

    it "prevents lands from being retapped" do
      expect(battlefield_can_be_tapped).to be_empty
    end
  end

  def battlefield_can_be_tapped
    available_actions[:ability].select{ |a| a.key == "tap" }.map{ |a| a.source.card }
  end

  it "lands can be tapped" do
    expect(battlefield_can_be_tapped).to eq(duel.player1.battlefield.map{ |b| b.card })
  end

  it "creatures cannot be tapped" do
    tap_all_lands
    create_creatures
    expect(battlefield_can_be_tapped).to be_empty
  end

  it "we can't play a creature if it's not our turn" do
    duel.current_player_number = 2
    duel.save!

    expect(available_actions[:play].map { |h| h.card }).to be_empty
  end

  it "we can't play a creature if it's not our priority, even with tapping" do
    duel.priority_player_number = 2
    duel.save!

    tap_all_lands

    expect(available_actions[:play].map { |h| h.card }).to be_empty
  end

  it "we can't play a creature if it's not our turn, even with tapping" do
    duel.current_player_number = 2
    duel.save!

    tap_all_lands

    expect(available_actions[:play].map { |h| h.card }).to be_empty
  end

end
