require "test_helper"

class BrandTest < ActiveSupport::TestCase
  # --- Validations ---

  test "is valid with valid attributes" do
    brand = Brand.new(name: "Dos en Uno", description: "Marca chilena")
    assert brand.valid?
  end

  test "requires a name" do
    brand = Brand.new(name: nil)
    assert_not brand.valid?
    assert_includes brand.errors[:name], "can't be blank"
  end

  test "requires a unique name (case insensitive)" do
    Brand.create!(name: "TestBrand")
    duplicate = Brand.new(name: "testbrand")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "defaults country_of_origin to Chile" do
    brand = Brand.new(name: "New Brand")
    assert_equal "Chile", brand.country_of_origin
  end

  # --- Slugs ---

  test "generates slug from name before validation" do
    brand = Brand.new(name: "Dos en Uno")
    brand.valid?
    assert_equal "dos-en-uno", brand.slug
  end

  test "regenerates slug when name changes" do
    brand = brands(:ambrosoli)
    brand.name = "Ambrosoli Chile"
    brand.valid?
    assert_equal "ambrosoli-chile", brand.slug
  end

  test "to_param returns slug" do
    assert_equal "ambrosoli", brands(:ambrosoli).to_param
  end

  test "requires a unique slug" do
    Brand.create!(name: "Test")
    duplicate = Brand.new(name: "Test")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:slug], "has already been taken"
  end

  # --- Associations ---

  test "has many candies" do
    assert_respond_to brands(:costa), :candies
  end

  test "cannot be deleted if it has candies" do
    brand = brands(:costa)
    assert_not brand.destroy
    assert_includes brand.errors[:base], "Cannot delete record because dependent candies exist"
  end
end
