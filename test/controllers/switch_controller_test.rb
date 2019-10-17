require 'test_helper'

class SwitchControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get switch_show_url
    assert_response :success
  end

  test "should get commit" do
    get switch_commit_url
    assert_response :success
  end

end
