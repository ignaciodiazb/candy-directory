class CategoriesController < ApplicationController
  before_action :set_category, only: :show

  def index
    @categories = Category.order(:name)
  end

  def show
    @candies = @category.candies.includes(:brand).order(:name)
  end

  private

  def set_category
    @category = Category.find_by!(slug: params[:id])
  end
end
