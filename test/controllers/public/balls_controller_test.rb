require "test_helper"

class Public::BallsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_balls_index_url
    assert_response :success
  end

  test "should get new" do
    get public_balls_new_url
    assert_response :success
  end

  test "should get show" do
    get public_balls_show_url
    assert_response :success
  end

  test "should get destroy" do
    get public_balls_destroy_url
    assert_response :success
  end

  test "should get create" do
    get public_balls_create_url
    assert_response :success
  end
end
