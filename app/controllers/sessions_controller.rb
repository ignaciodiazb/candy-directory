class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Demasiados intentos. Inténtalo más tarde." }

  def new
  end

  def create
    if user = User.authenticate_by(params.expect(session: [ :email_address, :password ]))
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Sesión iniciada."
    else
      redirect_to new_session_path, alert: "Email o contraseña inválidos."
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "Sesión cerrada.", status: :see_other
  end
end
