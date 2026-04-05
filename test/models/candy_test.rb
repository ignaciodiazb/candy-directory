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

  # --- Scopes ---

  test "active scope excludes discontinued candies" do
    assert_not_includes Candy.active, candies(:negrita)
  end

  test "active scope includes non-discontinued candies" do
    assert_includes Candy.active, candies(:super_ocho)
  end

  test "search scope finds by name" do
    results = Candy.search("Super")
    assert_includes results, candies(:super_ocho)
    assert_not_includes results, candies(:mentita)
  end

  test "search scope finds by description" do
    results = Candy.search("oblea")
    assert_includes results, candies(:super_ocho)
  end

  test "search scope is case-insensitive" do
    assert_includes Candy.search("super ocho"), candies(:super_ocho)
  end

  test "search scope returns all when term is blank" do
    assert_equal Candy.count, Candy.search("").count
    assert_equal Candy.count, Candy.search(nil).count
  end

  test "by_brand scope filters by brand_id" do
    costa = brands(:costa)
    results = Candy.by_brand(costa.id)
    assert results.all? { |c| c.brand_id == costa.id }
    assert_includes results, candies(:super_ocho)
    assert_not_includes results, candies(:mentita)
  end

  test "by_brand scope returns all when given nil" do
    assert_equal Candy.count, Candy.by_brand(nil).count
  end

  test "by_category scope filters by category_id" do
    chocolate = categories(:chocolate)
    results = Candy.by_category(chocolate.id)
    assert results.all? { |c| c.category_id == chocolate.id }
    assert_includes results, candies(:super_ocho)
    assert_not_includes results, candies(:mentita)
  end

  test "by_category scope returns all when given nil" do
    assert_equal Candy.count, Candy.by_category(nil).count
  end

  test "scopes can be chained" do
    results = Candy.active.by_brand(brands(:costa).id).search("ocho")
    assert_includes results, candies(:super_ocho)
    assert_equal 1, results.count
  end
end
