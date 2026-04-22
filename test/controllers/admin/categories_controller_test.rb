require "test_helper"

class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  # --- auth ---

  test "index redirects to login when unauthenticated" do
    get admin_categories_path
    assert_redirected_to new_session_url
  end

  test "index redirects to root when signed in as non-admin" do
    sign_in_as users(:regular)
    get admin_categories_path
    assert_redirected_to root_path
  end

  # --- index ---

  test "index returns success" do
    sign_in_as users(:admin)
    get admin_categories_path
    assert_response :success
  end

  # --- show ---

  test "show returns success" do
    sign_in_as users(:admin)
    get admin_category_path(categories(:chocolate))
    assert_response :success
  end

  # --- new ---

  test "new returns success" do
    sign_in_as users(:admin)
    get new_admin_category_path
    assert_response :success
  end

  # --- create ---

  test "create with valid params creates category and redirects" do
    sign_in_as users(:admin)
    assert_difference("Category.count") do
      post admin_categories_path,
        params: { category: { name: "Chupete" } }
    end
    assert_redirected_to admin_categories_path
    assert_equal "Categoría creada exitosamente.", flash[:notice]
  end

  test "create with invalid params renders new with 422" do
    sign_in_as users(:admin)
    assert_no_difference("Category.count") do
      post admin_categories_path, params: { category: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  # --- edit ---

  test "edit returns success" do
    sign_in_as users(:admin)
    get edit_admin_category_path(categories(:chocolate))
    assert_response :success
  end

  # --- update ---

  test "update with valid params updates category and redirects" do
    sign_in_as users(:admin)
    patch admin_category_path(categories(:caramelo)),
      params: { category: { description: "Descripción actualizada." } }
    assert_redirected_to admin_categories_path
    assert_equal "Categoría actualizada exitosamente.", flash[:notice]
  end

  test "update with invalid params renders edit with 422" do
    sign_in_as users(:admin)
    patch admin_category_path(categories(:chocolate)),
      params: { category: { name: "" } }
    assert_response :unprocessable_entity
  end

  # --- destroy ---

  test "destroy category without candies succeeds" do
    sign_in_as users(:admin)
    category = Category.create!(name: "Gomita")
    assert_difference("Category.count", -1) do
      delete admin_category_path(category)
    end
    assert_redirected_to admin_categories_path
    assert_equal "Categoría eliminada exitosamente.", flash[:notice]
  end

  test "destroy category with candies fails and shows alert" do
    sign_in_as users(:admin)
    assert_no_difference("Category.count") do
      delete admin_category_path(categories(:chocolate))
    end
    assert_redirected_to admin_categories_path
    assert flash[:alert].present?
  end
end
