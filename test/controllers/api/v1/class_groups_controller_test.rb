require "test_helper"

class Api::V1::ClassGroupsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_class_groups_index_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_class_groups_create_url
    assert_response :success
  end

  test "should get add_student" do
    get api_v1_class_groups_add_student_url
    assert_response :success
  end
end
