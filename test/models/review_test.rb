require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  # --- Validations ---

  test "is valid with valid attributes" do
    review = Review.new(
      candy: candies(:mentita),
      user: users(:regular),
      rating: 4,
      body: "Muy buen sabor a menta."
    )
    assert review.valid?
  end

  test "requires a rating" do
    review = Review.new(candy: candies(:mentita), user: users(:regular), body: "Bueno")
    assert_not review.valid?
    assert_includes review.errors[:rating], "can't be blank"
  end

  test "rating must be between 1 and 5" do
    [ 0, 6 ].each do |bad_rating|
      review = Review.new(candy: candies(:mentita), user: users(:regular), rating: bad_rating, body: "Test body here")
      assert_not review.valid?, "expected #{bad_rating} to be invalid"
      assert_includes review.errors[:rating], "is not included in the list"
    end
  end

  test "rating can be 1 through 5" do
    (1..5).each do |valid_rating|
      review = Review.new(candy: candies(:mentita), user: users(:regular), rating: valid_rating, body: "Test body here")
      assert review.valid?, "expected #{valid_rating} to be valid"
    end
  end

  test "requires a body" do
    review = Review.new(candy: candies(:mentita), user: users(:regular), rating: 3)
    assert_not review.valid?
    assert_includes review.errors[:body], "can't be blank"
  end

  test "body must be at least 5 characters" do
    review = Review.new(candy: candies(:mentita), user: users(:regular), rating: 3, body: "Mal")
    assert_not review.valid?
    assert_includes review.errors[:body], "is too short (minimum is 5 characters)"
  end

  test "body can be at most 2000 characters" do
    review = Review.new(candy: candies(:mentita), user: users(:regular), rating: 3, body: "a" * 2001)
    assert_not review.valid?
    assert_includes review.errors[:body], "is too long (maximum is 2000 characters)"
  end

  test "user can only review a candy once" do
    review = Review.new(
      candy: candies(:super_ocho),
      user: users(:admin),
      rating: 3,
      body: "Duplicate review attempt"
    )
    assert_not review.valid?
    assert_includes review.errors[:user_id], "has already reviewed this candy"
  end

  test "different users can review the same candy" do
    review = Review.new(
      candy: candies(:caluga_media_hora),
      user: users(:admin),
      rating: 4,
      body: "La caluga favorita de mi abuela."
    )
    assert review.valid?
  end

  # --- Associations ---

  test "belongs to a candy" do
    assert_equal candies(:super_ocho), reviews(:admin_review_super_ocho).candy
  end

  test "belongs to a user" do
    assert_equal users(:admin), reviews(:admin_review_super_ocho).user
  end

  test "candy has many reviews" do
    assert_includes candies(:super_ocho).reviews, reviews(:admin_review_super_ocho)
    assert_includes candies(:super_ocho).reviews, reviews(:regular_review_super_ocho)
  end

  # --- Scopes ---

  test "recent scope orders by created_at descending" do
    candy = candies(:caluga_media_hora)
    older = Review.create!(candy: candy, user: users(:regular), rating: 3, body: "Older review body.", created_at: 2.days.ago)
    newer = Review.create!(candy: candy, user: users(:admin), rating: 5, body: "Newer review body.", created_at: 1.day.ago)
    results = candy.reviews.recent.to_a
    assert_equal newer, results.first
    assert_equal older, results.last
  end

  # --- Counter cache ---

  test "counter cache increments reviews_count on candy" do
    candy = candies(:caluga_media_hora)
    initial_count = candy.reviews_count
    Review.create!(candy: candy, user: users(:regular), rating: 4, body: "Me gusta la caluga.")
    assert_equal initial_count + 1, candy.reload.reviews_count
  end

  test "counter cache decrements reviews_count on candy" do
    review = reviews(:admin_review_super_ocho)
    candy = review.candy
    initial_count = candy.reviews_count
    review.destroy
    assert_equal initial_count - 1, candy.reload.reviews_count
  end

  # --- Callback: ratings_average ---

  test "creating a review updates candy ratings_average" do
    candy = candies(:caluga_media_hora)
    Review.create!(candy: candy, user: users(:admin), rating: 4, body: "Excelente caluga blanda.")
    assert_in_delta 4.0, candy.reload.ratings_average, 0.01
  end

  test "destroying a review recalculates candy ratings_average" do
    candy = candies(:super_ocho)
    reviews(:admin_review_super_ocho).destroy
    expected_avg = candy.reviews.average(:rating).to_f
    assert_in_delta expected_avg, candy.reload.ratings_average, 0.01
  end

  test "ratings_average is zero when all reviews are destroyed" do
    candy = candies(:cocoa)
    candy.reviews.each(&:destroy)
    assert_equal 0.0, candy.reload.ratings_average
  end
end
