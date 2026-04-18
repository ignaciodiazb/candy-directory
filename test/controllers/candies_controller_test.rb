require "test_helper"

class CandiesControllerTest < ActionDispatch::IntegrationTest
  # --- index ---

  test "index returns success" do
    get candies_path
    assert_response :success
  end

  test "index filters by search term" do
    get candies_path(q: "Super")
    assert_response :success
    assert_match "Super Ocho", response.body
    assert_no_match "Mentita", response.body
  end

  test "index filters by brand slug" do
    get candies_path(brand: "costa")
    assert_response :success
    assert_match "Super Ocho", response.body
    assert_no_match "Mentita", response.body
  end

  test "index filters by category slug" do
    get candies_path(category: "caramelos")
    assert_response :success
    assert_match "Mentita", response.body
    assert_no_match "Super Ocho", response.body
  end

  test "index hides discontinued by default" do
    get candies_path
    assert_response :success
    assert_no_match "Negrita", response.body
  end

  test "index shows discontinued when requested" do
    get candies_path(show_discontinued: "1")
    assert_response :success
    assert_match "Negrita", response.body
  end

  test "index with combined search and brand filter" do
    get candies_path(q: "chocolate", brand: "costa")
    assert_response :success
  end

  test "index with invalid brand slug ignores filter and returns success" do
    get candies_path(brand: "nonexistent-brand")
    assert_response :success
  end

  test "index with no results shows empty state" do
    get candies_path(q: "zzzznotfound")
    assert_response :success
    assert_match "No se encontraron dulces", response.body
  end

  # --- show ---

  test "show returns success" do
    get candy_path(candies(:super_ocho))
    assert_response :success
  end

  test "show with invalid slug returns not found" do
    get candy_path(id: "nonexistent-candy")
    assert_response :not_found
  end

  test "show renders 200 for candy with attached photo" do
    candy = candies(:super_ocho)
    candy.photo.attach(fixture_file_upload("candy.png", "image/png"))
    get candy_path(candy)
    assert_response :success
  end
end
