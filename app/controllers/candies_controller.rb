class CandiesController < ApplicationController
  allow_unauthenticated_access
  before_action :set_candy, only: :show

  def index
    @candies = Candy.includes(:brand, :category)
    @candies = @candies.active unless params[:show_discontinued] == "1"
    @candies = @candies.by_brand(brand_from_slug&.id)
    @candies = @candies.by_category(category_from_slug&.id)
    @candies = @candies.search(params[:q])
    @candies = @candies.order(:name)

    @brands = Brand.order(:name)
    @categories = Category.order(:name)
  end

  def show
  end

  private

  def set_candy
    @candy = Candy.find_by!(slug: params[:id])
  end

  def brand_from_slug
    Brand.find_by(slug: params[:brand]) if params[:brand].present?
  end

  def category_from_slug
    Category.find_by(slug: params[:category]) if params[:category].present?
  end
end
