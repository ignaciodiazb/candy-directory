class Candy < ApplicationRecord
  include Sluggable

  belongs_to :brand
  belongs_to :category

  validates :name, presence: true
  validates :year_introduced, numericality: { only_integer: true }, allow_nil: true

  scope :active, -> { where(discontinued: false) }

  scope :search, ->(term) {
    if term.present?
      where("name LIKE :term OR description LIKE :term", term: "%#{sanitize_sql_like(term)}%")
    else
      all
    end
  }

  scope :by_brand, ->(brand_id) {
    brand_id.present? ? where(brand_id: brand_id) : all
  }

  scope :by_category, ->(category_id) {
    category_id.present? ? where(category_id: category_id) : all
  }
end
