class Brand < ApplicationRecord
  include Sluggable

  has_many :candies, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
