class BrandsController < ApplicationController
  before_action :set_brand, only: :show

  def index
    @brands = Brand.order(:name)
  end

  def show
    @candies = @brand.candies.includes(:category).order(:name)
  end

  private

  def set_brand
    @brand = Brand.find_by!(slug: params[:id])
  end
end
