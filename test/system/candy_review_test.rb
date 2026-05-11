require "application_system_test_case"

class CandyReviewTest < ApplicationSystemTestCase
  def sign_in_as_regular
    visit new_session_path
    fill_in "Email", with: users(:regular).email_address
    fill_in "Contraseña", with: "password"
    click_button "Iniciar sesión"
    # Wait for the Turbo Drive redirect chain to finish: regular user is sent
    # to /admin and then bounced back to / with an alert. Without this wait,
    # subsequent visits race the redirects and the session cookie is missed.
    assert_current_path root_path
  end

  test "signed-in user can submit a review and see it without page reload" do
    sign_in_as_regular
    visit candy_path(candies(:caluga_media_hora))

    assert_selector "h2", text: "Reseñas"
    assert_selector "#new_review"

    within "#new_review" do
      select "★★★★ (4)", from: "Calificación"
      fill_in "Reseña", with: "Me encanta esta caluga, es súper suave."
      click_on "Publicar reseña"
    end

    assert_selector "#reviews_list .review-card", text: "Me encanta esta caluga"
    assert_selector "#new_review h3", text: "Editar reseña"
  end

  test "signed-in user can delete their own review" do
    sign_in_as_regular
    visit candy_path(candies(:super_ocho))

    assert_selector "#reviews_list .review-card", text: reviews(:regular_review_super_ocho).body

    within "##{dom_id(reviews(:regular_review_super_ocho))}" do
      accept_confirm { click_on "Eliminar" }
    end

    assert_no_selector "##{dom_id(reviews(:regular_review_super_ocho))}"
    assert_selector "#new_review h3", text: "Escribe una reseña"
  end

  test "unauthenticated visitor sees sign-in prompt instead of form" do
    visit candy_path(candies(:super_ocho))
    assert_selector "#new_review", text: "Inicia sesión"
    assert_no_selector "#new_review form"
  end
end
