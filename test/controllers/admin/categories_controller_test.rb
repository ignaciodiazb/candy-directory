require "test_helper"

class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  def admin_headers
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(
      Rails.application.credentials.dig(:admin, :username),
      Rails.application.credentials.dig(:admin, :password)
    )
    { "Authorization" => credentials }
  end

  # --- auth ---

  test "index requires authentication" do
    get admin_categories_path
    assert_response :unauthorized
  end

  # --- index ---

  test "index returns success" do
    get admin_categories_path, headers: admin_headers
    assert_response :success
  end

  # --- show ---

  test "show returns success" do
    get admin_category_path(categories(:chocolate)), headers: admin_headers
    assert_response :success
  end

  # --- new ---

  test "new returns success" do
    get new_admin_category_path, headers: admin_headers
    assert_response :success
  end

  # --- create ---

  test "create with valid params creates category and redirects" do
    assert_difference("Category.count") do
      post admin_categories_path,
        params: { category: { name: "Chupete" } },
        headers: admin_headers
    end
    assert_redirected_to admin_categories_path
    assert_equal "Categoría creada exitosamente.", flash[:notice]
  end

  test "create with invalid params renders new with 422" do
    assert_no_difference("Category.count") do
      post admin_categories_path, params: { category: { name: "" } }, headers: admin_headers
    end
    assert_response :unprocessable_entity
  end

  # --- edit ---

  test "edit returns success" do
    get edit_admin_category_path(categories(:chocolate)), headers: admin_headers
    assert_response :success
  end

  # --- update ---

  test "update with valid params updates category and redirects" do
    patch admin_category_path(categories(:caramelo)),
      params: { category: { description: "Descripción actualizada." } },
      headers: admin_headers
    assert_redirected_to admin_categories_path
    assert_equal "Categoría actualizada exitosamente.", flash[:notice]
  end

  test "update with invalid params renders edit with 422" do
    patch admin_category_path(categories(:chocolate)),
      params: { category: { name: "" } },
      headers: admin_headers
    assert_response :unprocessable_entity
  end

  # --- destroy ---

  test "destroy category without candies succeeds" do
    category = Category.create!(name: "Gomita")
    assert_difference("Category.count", -1) do
      delete admin_category_path(category), headers: admin_headers
    end
    assert_redirected_to admin_categories_path
    assert_equal "Categoría eliminada exitosamente.", flash[:notice]
  end

  test "destroy category with candies fails and shows alert" do
    assert_no_difference("Category.count") do
      delete admin_category_path(categories(:chocolate)), headers: admin_headers
    end
    assert_redirected_to admin_categories_path
    assert flash[:alert].present?
  end
end
