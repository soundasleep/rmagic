require 'rails_helper'

RSpec.describe DuelController, type: :controller do
  context "when not logged in" do
    context "GET new" do
      it "redirects to a login page" do
        post :create
        assert_response :redirect
      end
    end
  end
end
