require "test_helper"

class Api::V1::ThemesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_themes_index_url
    assert_response :success
  end

  test "should get create" do
    get api_v1_themes_create_url
    assert_response :success
  end
end
