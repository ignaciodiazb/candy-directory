require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  # --- index ---

  test "index returns success" do
    get categories_path
    assert_response :success
  end

  # --- show ---

  test "show returns success" do
    get category_path(categories(:chocolate))
    assert_response :success
  end

  test "show with invalid slug returns not found" do
    get category_path(id: "nonexistent-category")
    assert_response :not_found
  end
end
