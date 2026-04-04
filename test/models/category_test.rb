require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  # --- Validations ---

  test "is valid with valid attributes" do
    category = Category.new(name: "Gomita", description: "Gummy candies")
    assert category.valid?
  end

  test "requires a name" do
    category = Category.new(name: nil)
    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
  end

  test "requires a unique name (case insensitive)" do
    Category.create!(name: "TestCategory")
    duplicate = Category.new(name: "testcategory")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  # --- Slugs ---

  test "generates slug from name" do
    category = Category.new(name: "Barra de Chocolate")
    category.valid?
    assert_equal "barra-de-chocolate", category.slug
  end

  test "to_param returns slug" do
    assert_equal "chocolate", categories(:chocolate).to_param
  end

  # --- Associations ---

  test "has many candies" do
    assert_respond_to categories(:chocolate), :candies
  end

  test "cannot be deleted if it has candies" do
    category = categories(:chocolate)
    assert_not category.destroy
    assert_includes category.errors[:base], "Cannot delete record because dependent candies exist"
  end
end
