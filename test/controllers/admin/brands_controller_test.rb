require "test_helper"

class Admin::BrandsControllerTest < ActionDispatch::IntegrationTest
  # --- auth ---

  test "index redirects to login when unauthenticated" do
    get admin_brands_path
    assert_redirected_to new_session_url
  end

  test "index redirects to root when signed in as non-admin" do
    sign_in_as users(:regular)
    get admin_brands_path
    assert_redirected_to root_path
  end

  # --- index ---

  test "index returns success" do
    sign_in_as users(:admin)
    get admin_brands_path
    assert_response :success
  end

  # --- show ---

  test "show returns success" do
    sign_in_as users(:admin)
    get admin_brand_path(brands(:ambrosoli))
    assert_response :success
  end

  # --- new ---

  test "new returns success" do
    sign_in_as users(:admin)
    get new_admin_brand_path
    assert_response :success
  end

  # --- create ---

  test "create with valid params creates brand and redirects" do
    sign_in_as users(:admin)
    assert_difference("Brand.count") do
      post admin_brands_path,
        params: { brand: { name: "McKay", country_of_origin: "Chile" } }
    end
    assert_redirected_to admin_brands_path
    assert_equal "Marca creada exitosamente.", flash[:notice]
  end

  test "create with invalid params renders new with 422" do
    sign_in_as users(:admin)
    assert_no_difference("Brand.count") do
      post admin_brands_path, params: { brand: { name: "" } }
    end
    assert_response :unprocessable_entity
  end

  # --- edit ---

  test "edit returns success" do
    sign_in_as users(:admin)
    get edit_admin_brand_path(brands(:ambrosoli))
    assert_response :success
  end

  # --- update ---

  test "update with valid params updates brand and redirects" do
    sign_in_as users(:admin)
    patch admin_brand_path(brands(:ambrosoli)),
      params: { brand: { description: "Descripción actualizada." } }
    assert_redirected_to admin_brands_path
    assert_equal "Marca actualizada exitosamente.", flash[:notice]
  end

  test "update with invalid params renders edit with 422" do
    sign_in_as users(:admin)
    patch admin_brand_path(brands(:ambrosoli)),
      params: { brand: { name: "" } }
    assert_response :unprocessable_entity
  end

  # --- destroy ---

  test "destroy brand without candies succeeds" do
    sign_in_as users(:admin)
    brand = Brand.create!(name: "Dos en Uno", country_of_origin: "Chile")
    assert_difference("Brand.count", -1) do
      delete admin_brand_path(brand)
    end
    assert_redirected_to admin_brands_path
    assert_equal "Marca eliminada exitosamente.", flash[:notice]
  end

  test "destroy brand with candies fails and shows alert" do
    sign_in_as users(:admin)
    assert_no_difference("Brand.count") do
      delete admin_brand_path(brands(:costa))
    end
    assert_redirected_to admin_brands_path
    assert flash[:alert].present?
  end
end
