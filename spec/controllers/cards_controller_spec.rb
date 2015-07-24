require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  render_views    # needed for response.body tests

  context "GET index" do
    let(:forest) { Library::BasicCreature.new }

    before :each do
      get :index
    end

    it "exists" do
      assert_response :ok
    end

    it "shows the Forest card" do
      expect(response.body).to include(forest.name)
    end
  end

  context "GET show/1" do
    let(:card) { Library::BasicCreature.new }

    before :each do
      get :show, id: card.metaverse_id
    end

    it "exists" do
      assert_response :ok
    end

    it "shows the card name" do
      expect(response.body).to include(card.name)
    end
  end

  context "GET show/-1" do
    it "throws an error" do
      expect {
        get :show, id: -1
      }.to raise_error RuntimeError
    end
  end
end
