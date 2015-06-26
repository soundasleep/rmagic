require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET new" do
    it "exists" do
      get :new
      assert_response :ok
    end
  end
end
