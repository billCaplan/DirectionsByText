require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  test "should get reply" do
    get :reply
    assert_response :success
  end

end
