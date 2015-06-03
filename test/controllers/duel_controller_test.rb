require 'test_helper'

class DuelControllerTest < ActionController::TestCase
  test "should be able to create a new duel" do
    get :new
    assert_response :redirect
  end

end
