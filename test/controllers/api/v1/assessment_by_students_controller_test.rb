require "test_helper"

class Api::V1::AssessmentByStudentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_assessment_by_students_index_url
    assert_response :success
  end

  test "should get submit" do
    get api_v1_assessment_by_students_submit_url
    assert_response :success
  end
end
