require "game_helper"

RSpec.describe AddXLifeToTheTargetPlayer, type: :action do
  let(:duel) { create_game }
  let(:text) { "add 1 life to the target player" }
  let(:action) { TextualActions.new(text) }

  it "the player has 20 life" do
    expect(player1.life).to eq(20)
  end

  context "when executed" do
    before :each do
      stack = duel.stack.create! player: player1, card: player1.battlefield.first.card, order: 1, key: "test"
      stack.player_targets.create! target: player1
      action.execute(duel, stack)
    end

    it "the player still has 20 life" do
      # i.e. it hasn't resolved yet
      expect(player1.life).to eq(20)

      # we don't add a test for when it resolves because then we
      # need to set up the entire card infrastructure too, which
      # is already tested in spec/games/*
    end
  end
end
