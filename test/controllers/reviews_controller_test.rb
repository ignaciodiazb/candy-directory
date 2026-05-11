require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  def valid_review_params
    { review: { rating: 4, body: "Muy buen dulce chileno." } }
  end

  # --- auth ---

  test "create redirects to login when unauthenticated" do
    post candy_reviews_path(candies(:super_ocho)), params: valid_review_params
    assert_redirected_to new_session_url
  end

  test "update redirects to login when unauthenticated" do
    patch candy_review_path(candies(:super_ocho), reviews(:admin_review_super_ocho)),
          params: valid_review_params
    assert_redirected_to new_session_url
  end

  test "destroy redirects to login when unauthenticated" do
    delete candy_review_path(candies(:super_ocho), reviews(:admin_review_super_ocho))
    assert_redirected_to new_session_url
  end

  # --- create ---

  test "create succeeds with valid params" do
    sign_in_as users(:regular)
    assert_difference("Review.count") do
      post candy_reviews_path(candies(:caluga_media_hora)), params: valid_review_params
    end
    assert_response :redirect
  end

  test "create with turbo stream returns turbo stream response" do
    sign_in_as users(:regular)
    assert_difference("Review.count") do
      post candy_reviews_path(candies(:caluga_media_hora)),
           params: valid_review_params,
           headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  test "create fails with invalid params" do
    sign_in_as users(:regular)
    assert_no_difference("Review.count") do
      post candy_reviews_path(candies(:caluga_media_hora)),
           params: { review: { rating: 6, body: "x" } },
           headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end
    assert_response :unprocessable_entity
  end

  test "create prevents duplicate review from same user" do
    sign_in_as users(:admin)
    assert_no_difference("Review.count") do
      post candy_reviews_path(candies(:super_ocho)), params: valid_review_params
    end
  end

  # --- update ---

  test "owner can update their own review" do
    sign_in_as users(:admin)
    patch candy_review_path(candies(:super_ocho), reviews(:admin_review_super_ocho)),
          params: { review: { rating: 3, body: "Updated opinion about this candy." } }
    assert_response :redirect
    assert_equal 3, reviews(:admin_review_super_ocho).reload.rating
  end

  test "non-owner cannot update another user's review" do
    sign_in_as users(:regular)
    patch candy_review_path(candies(:super_ocho), reviews(:admin_review_super_ocho)),
          params: valid_review_params
    assert_redirected_to candy_path(candies(:super_ocho))
  end

  test "admin cannot update another user's review" do
    sign_in_as users(:admin)
    patch candy_review_path(candies(:super_ocho), reviews(:regular_review_super_ocho)),
          params: valid_review_params
    assert_redirected_to candy_path(candies(:super_ocho))
  end

  # --- destroy ---

  test "owner can destroy their own review" do
    sign_in_as users(:regular)
    assert_difference("Review.count", -1) do
      delete candy_review_path(candies(:super_ocho), reviews(:regular_review_super_ocho))
    end
    assert_response :redirect
  end

  test "admin can destroy any review" do
    sign_in_as users(:admin)
    assert_difference("Review.count", -1) do
      delete candy_review_path(candies(:super_ocho), reviews(:regular_review_super_ocho))
    end
    assert_response :redirect
  end

  test "non-owner non-admin cannot destroy another user's review" do
    sign_in_as users(:regular)
    assert_no_difference("Review.count") do
      delete candy_review_path(candies(:super_ocho), reviews(:admin_review_super_ocho))
    end
    assert_redirected_to candy_path(candies(:super_ocho))
  end
end
