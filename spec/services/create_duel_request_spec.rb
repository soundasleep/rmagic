require 'game_helper'

RSpec.describe CreateDuelRequest, type: :service do
  include CreatePremadeDecks

  let(:user) { User.create! name: "System" }
  let(:deck1) { create_larger_premade_deck(user) }

  it "the user has no requests" do
    expect(user.duel_requests).to be_empty
  end

  context "creating a duel request" do
    let(:service) { CreateDuelRequest.new(user: user, premade_deck: deck1) }

    it "returns true" do
      expect(service.call).to be(true)
    end

    context "and calling it" do
      before { service.call }

      it "the user has one request" do
        expect(user.duel_requests.length).to eq(1)
      end

      context "creating another duel request" do
        let(:service2) { CreateDuelRequest.new(user: user, premade_deck: deck1) }

        it "returns a duel" do
          expect(service2.call).to be_kind_of(Duel)
        end

        let(:duel) { service2.call }

        context "the created duel" do
          it "player1 is system user" do
            expect(duel.player1.user).to eq(user)
          end

          it "player2 is system user" do
            expect(duel.player2.user).to eq(user)
          end

          context "and calling it" do
            before { service.call }

            it "the user has no requests" do
              user.reload
              expect(user.duel_requests).to be_empty
            end
          end
        end
      end
    end
  end

end
