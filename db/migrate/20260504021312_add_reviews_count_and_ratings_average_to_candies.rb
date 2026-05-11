class AddReviewsCountAndRatingsAverageToCandies < ActiveRecord::Migration[8.1]
  def change
    add_column :candies, :reviews_count, :integer, null: false, default: 0, if_not_exists: true
    add_column :candies, :ratings_average, :float, null: false, default: 0.0, if_not_exists: true
  end
end
