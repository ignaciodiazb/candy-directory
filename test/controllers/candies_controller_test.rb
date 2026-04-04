require "test_helper"

class CandiesControllerTest < ActionDispatch::IntegrationTest
  # --- index ---

  test "index returns success" do
    get candies_path
    assert_response :success
  end

  # --- show ---

  test "show returns success" do
    get candy_path(candies(:super_ocho))
    assert_response :success
  end

  test "show with invalid slug returns not found" do
    get candy_path(id: "nonexistent-candy")
    assert_response :not_found
  end
end
