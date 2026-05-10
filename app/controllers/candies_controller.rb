class CandiesController < ApplicationController
  allow_unauthenticated_access
  before_action :set_candy, only: :show

  def index
    scope = Candy.includes(:brand, :category)
    scope = scope.active unless params[:show_discontinued] == "1"
    scope = scope.by_brand(brand_from_slug&.id)
    scope = scope.by_category(category_from_slug&.id)
    scope = scope.search(params[:q])
    scope = scope.order(:name)

    @pagy, @candies = pagy(scope)

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
