require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe "GET index" do
    it "exists" do
      post :index
      assert_response :ok
    end
  end
end
