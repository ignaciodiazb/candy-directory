require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "new renders login form" do
    get new_session_path
    assert_response :success
  end

  test "create with valid credentials signs in and redirects to admin" do
    post session_path, params: { session: { email_address: users(:admin).email_address, password: "password" } }
    assert_redirected_to admin_root_url
    assert cookies[:session_id]
    assert_equal "Sesión iniciada.", flash[:notice]
  end

  test "create with invalid credentials redirects back with alert" do
    post session_path, params: { session: { email_address: users(:admin).email_address, password: "wrong" } }
    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
    assert_equal "Email o contraseña inválidos.", flash[:alert]
  end

  test "destroy signs out and redirects to root" do
    sign_in_as users(:admin)
    delete session_path
    assert_redirected_to root_path
    assert_empty cookies[:session_id]
    assert_equal "Sesión cerrada.", flash[:notice]
  end
end
