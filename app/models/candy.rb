class Candy < ApplicationRecord
  include Sluggable

  belongs_to :brand
  belongs_to :category

  validates :name, presence: true
  validates :year_introduced, numericality: { only_integer: true }, allow_nil: true
end
