class CandiesController < ApplicationController
  before_action :set_candy, only: :show

  def index
    @candies = Candy.includes(:brand, :category).order(:name)
  end

  def show
  end

  private

  def set_candy
    @candy = Candy.find_by!(slug: params[:id])
  end
end
