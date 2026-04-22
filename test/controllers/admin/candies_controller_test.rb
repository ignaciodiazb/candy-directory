require "test_helper"

class Admin::CandiesControllerTest < ActionDispatch::IntegrationTest
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

  test "index redirects to login when unauthenticated" do
    get admin_candies_path
    assert_redirected_to new_session_url
  end

  test "create redirects to login when unauthenticated" do
    post admin_candies_path, params: valid_candy_params
    assert_redirected_to new_session_url
  end

  test "destroy redirects to login when unauthenticated" do
    delete admin_candy_path(candies(:super_ocho))
    assert_redirected_to new_session_url
  end

  test "index redirects to root when signed in as non-admin" do
    sign_in_as users(:regular)
    get admin_candies_path
    assert_redirected_to root_path
  end

  # --- index ---

  test "index returns success" do
    sign_in_as users(:admin)
    get admin_candies_path
    assert_response :success
  end

  # --- show ---

  test "show returns success" do
    sign_in_as users(:admin)
    get admin_candy_path(candies(:super_ocho))
    assert_response :success
  end

  # --- new ---

  test "new returns success" do
    sign_in_as users(:admin)
    get new_admin_candy_path
    assert_response :success
  end

  # --- create ---

  test "create with valid params creates candy and redirects" do
    sign_in_as users(:admin)
    assert_difference("Candy.count") do
      post admin_candies_path, params: valid_candy_params
    end
    assert_redirected_to admin_candies_path
    assert_equal "Dulce creado exitosamente.", flash[:notice]
  end

  test "create with invalid params renders new with 422" do
    sign_in_as users(:admin)
    assert_no_difference("Candy.count") do
      post admin_candies_path,
        params: { candy: { name: "", brand_id: brands(:ambrosoli).id, category_id: categories(:chocolate).id } }
    end
    assert_response :unprocessable_entity
  end

  # --- edit ---

  test "edit returns success" do
    sign_in_as users(:admin)
    get edit_admin_candy_path(candies(:super_ocho))
    assert_response :success
  end

  # --- update ---

  test "update with valid params updates candy and redirects" do
    sign_in_as users(:admin)
    patch admin_candy_path(candies(:cocoa)),
      params: { candy: { name: "Cocoa Actualizado" } }
    assert_redirected_to admin_candies_path
    assert_equal "Dulce actualizado exitosamente.", flash[:notice]
    assert_equal "Cocoa Actualizado", candies(:cocoa).reload.name
  end

  test "update with invalid params renders edit with 422" do
    sign_in_as users(:admin)
    patch admin_candy_path(candies(:super_ocho)),
      params: { candy: { name: "" } }
    assert_response :unprocessable_entity
  end

  # --- destroy ---

  test "destroy deletes candy and redirects" do
    sign_in_as users(:admin)
    assert_difference("Candy.count", -1) do
      delete admin_candy_path(candies(:mentita))
    end
    assert_redirected_to admin_candies_path
    assert_equal "Dulce eliminado exitosamente.", flash[:notice]
  end

  # --- photo upload ---

  test "create with photo attaches the image" do
    sign_in_as users(:admin)
    photo = fixture_file_upload("candy.png", "image/png")
    assert_difference("Candy.count") do
      post admin_candies_path,
        params: valid_candy_params.deep_merge(candy: { photo: photo })
    end
    assert Candy.last.photo.attached?
  end
end
