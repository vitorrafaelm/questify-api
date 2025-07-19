require "test_helper"

class Api::V1::AssessmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_assessments_create_url
    assert_response :success
  end

  test "should get add_question" do
    get api_v1_assessments_add_question_url
    assert_response :success
  end

  test "should get assign_to_class_group" do
    get api_v1_assessments_assign_to_class_group_url
    assert_response :success
  end
end
