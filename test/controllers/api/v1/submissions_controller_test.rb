require "test_helper"

class Api::V1::SubmissionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get api_v1_submissions_show_url
    assert_response :success
  end

  test "should get grade" do
    get api_v1_submissions_grade_url
    assert_response :success
  end
end
