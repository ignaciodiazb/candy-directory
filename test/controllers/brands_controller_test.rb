require "test_helper"

class BrandsControllerTest < ActionDispatch::IntegrationTest
  # --- index ---

  test "index returns success" do
    get brands_path
    assert_response :success
  end

  # --- show ---

  test "show returns success" do
    get brand_path(brands(:costa))
    assert_response :success
  end

  test "show with invalid slug returns not found" do
    get brand_path(id: "nonexistent-brand")
    assert_response :not_found
  end
end
