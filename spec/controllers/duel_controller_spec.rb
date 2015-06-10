require 'rails_helper'

RSpec.describe DuelController do
  describe "GET new" do
    it "creates a new duel" do
      get :new
      assert_response :redirect
    end
  end
end
