class Review < ApplicationRecord
  belongs_to :candy, counter_cache: true
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :body, presence: true, length: { minimum: 5, maximum: 2000 }
  validates :user_id, uniqueness: { scope: :candy_id, message: "has already reviewed this candy" }

  scope :recent, -> { order(created_at: :desc) }

  after_save :recalculate_candy_rating
  after_destroy :recalculate_candy_rating

  private

  def recalculate_candy_rating
    avg = candy.reviews.average(:rating)&.to_f || 0.0
    candy.update_columns(ratings_average: avg)
  end
end
