class Admin::CandiesController < Admin::BaseController
  before_action :set_candy, only: %i[show edit update destroy]
  before_action :set_form_collections, only: %i[new edit create update]

  def index
    @candies = Candy.includes(:brand, :category).order(:name)
  end

  def show
  end

  def new
    @candy = Candy.new
  end

  def create
    @candy = Candy.new(candy_params)
    if @candy.save
      redirect_to admin_candies_path, notice: "Dulce creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @candy.update(candy_params)
      redirect_to admin_candies_path, notice: "Dulce actualizado exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @candy.destroy
    redirect_to admin_candies_path, notice: "Dulce eliminado exitosamente."
  end

  private

  def set_candy
    @candy = Candy.find_by!(slug: params[:id])
  end

  def set_form_collections
    @brands = Brand.order(:name)
    @categories = Category.order(:name)
  end

  def candy_params
    params.require(:candy).permit(:name, :description, :brand_id, :category_id, :year_introduced, :discontinued)
  end
end
