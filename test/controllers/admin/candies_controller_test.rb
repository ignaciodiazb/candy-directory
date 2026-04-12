require "test_helper"

class Admin::CandiesControllerTest < ActionDispatch::IntegrationTest
  def admin_headers
    credentials = ActionController::HttpAuthentication::Basic.encode_credentials(
      Rails.application.credentials.dig(:admin, :username),
      Rails.application.credentials.dig(:admin, :password)
    )
    { "Authorization" => credentials }
  end

  def valid_candy_params
    {
      candy: {
        name: "Nuevo Dulce Test",
        brand_id: brands(:ambrosoli).id,
        category_id: categories(:chocolate).id,
        discontinued: false
      }
    }
  end

  # --- auth ---

  test "index requires authentication" do
    get admin_candies_path
    assert_response :unauthorized
  end

  test "create requires authentication" do
    post admin_candies_path, params: valid_candy_params
    assert_response :unauthorized
  end

  test "destroy requires authentication" do
    delete admin_candy_path(candies(:super_ocho))
    assert_response :unauthorized
  end

  # --- index ---

  test "index returns success" do
    get admin_candies_path, headers: admin_headers
    assert_response :success
  end

  # --- show ---

  test "show returns success" do
    get admin_candy_path(candies(:super_ocho)), headers: admin_headers
    assert_response :success
  end

  # --- new ---

  test "new returns success" do
    get new_admin_candy_path, headers: admin_headers
    assert_response :success
  end

  # --- create ---

  test "create with valid params creates candy and redirects" do
    assert_difference("Candy.count") do
      post admin_candies_path, params: valid_candy_params, headers: admin_headers
    end
    assert_redirected_to admin_candies_path
    assert_equal "Dulce creado exitosamente.", flash[:notice]
  end

  test "create with invalid params renders new with 422" do
    assert_no_difference("Candy.count") do
      post admin_candies_path,
        params: { candy: { name: "", brand_id: brands(:ambrosoli).id, category_id: categories(:chocolate).id } },
        headers: admin_headers
    end
    assert_response :unprocessable_entity
  end

  # --- edit ---

  test "edit returns success" do
    get edit_admin_candy_path(candies(:super_ocho)), headers: admin_headers
    assert_response :success
  end

  # --- update ---

  test "update with valid params updates candy and redirects" do
    patch admin_candy_path(candies(:cocoa)),
      params: { candy: { name: "Cocoa Actualizado" } },
      headers: admin_headers
    assert_redirected_to admin_candies_path
    assert_equal "Dulce actualizado exitosamente.", flash[:notice]
    assert_equal "Cocoa Actualizado", candies(:cocoa).reload.name
  end

  test "update with invalid params renders edit with 422" do
    patch admin_candy_path(candies(:super_ocho)),
      params: { candy: { name: "" } },
      headers: admin_headers
    assert_response :unprocessable_entity
  end

  # --- destroy ---

  test "destroy deletes candy and redirects" do
    assert_difference("Candy.count", -1) do
      delete admin_candy_path(candies(:mentita)), headers: admin_headers
    end
    assert_redirected_to admin_candies_path
    assert_equal "Dulce eliminado exitosamente.", flash[:notice]
  end
end
