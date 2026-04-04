require "test_helper"

class CandyTest < ActiveSupport::TestCase
  # --- Validations ---

  test "is valid with valid attributes" do
    candy = Candy.new(
      name: "Triángulo",
      brand: brands(:costa),
      category: categories(:chocolate)
    )
    assert candy.valid?
  end

  test "requires a name" do
    candy = Candy.new(brand: brands(:costa), category: categories(:chocolate))
    assert_not candy.valid?
    assert_includes candy.errors[:name], "can't be blank"
  end

  test "requires a brand" do
    candy = Candy.new(name: "Orphan Candy", category: categories(:chocolate))
    assert_not candy.valid?
    assert_includes candy.errors[:brand], "must exist"
  end

  test "requires a category" do
    candy = Candy.new(name: "Orphan Candy", brand: brands(:costa))
    assert_not candy.valid?
    assert_includes candy.errors[:category], "must exist"
  end

  test "year_introduced must be an integer if present" do
    candy = Candy.new(
      name: "Bad Year",
      brand: brands(:costa),
      category: categories(:chocolate),
      year_introduced: 19.5
    )
    assert_not candy.valid?
    assert_includes candy.errors[:year_introduced], "must be an integer"
  end

  test "year_introduced can be nil" do
    candy = Candy.new(
      name: "No Year",
      brand: brands(:costa),
      category: categories(:chocolate),
      year_introduced: nil
    )
    assert candy.valid?
  end

  test "discontinued defaults to false" do
    candy = Candy.new(name: "New Candy", brand: brands(:costa), category: categories(:chocolate))
    assert_equal false, candy.discontinued
  end

  # --- Slugs ---

  test "generates slug from name" do
    candy = Candy.new(name: "Super Ocho Plus", brand: brands(:costa), category: categories(:chocolate))
    candy.valid?
    assert_equal "super-ocho-plus", candy.slug
  end

  test "to_param returns slug" do
    assert_equal "super-ocho", candies(:super_ocho).to_param
  end

  # --- Associations ---

  test "belongs to a brand" do
    assert_equal brands(:costa), candies(:super_ocho).brand
  end

  test "belongs to a category" do
    assert_equal categories(:chocolate), candies(:super_ocho).category
  end
end
