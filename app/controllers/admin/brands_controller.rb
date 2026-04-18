class Admin::BrandsController < Admin::BaseController
  before_action :set_brand, only: %i[show edit update destroy]

  def index
    @brands = Brand.order(:name)
  end

  def show
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      redirect_to admin_brands_path, notice: "Marca creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @brand.update(brand_params)
      redirect_to admin_brands_path, notice: "Marca actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @brand.destroy
      redirect_to admin_brands_path, notice: "Marca eliminada exitosamente."
    else
      redirect_to admin_brands_path, alert: @brand.errors.full_messages.to_sentence
    end
  end

  private

  def set_brand
    @brand = Brand.find_by!(slug: params[:id])
  end

  def brand_params
    params.expect(brand: [ :name, :description, :country_of_origin ])
  end
end
