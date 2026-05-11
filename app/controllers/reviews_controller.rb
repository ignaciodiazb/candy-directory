class ReviewsController < ApplicationController
  before_action :set_candy
  before_action :set_review, only: %i[update destroy]
  before_action :authorize_update!, only: :update
  before_action :authorize_destroy!, only: :destroy

  def create
    @review = @candy.reviews.build(review_params)
    @review.user = Current.user

    if @review.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @candy }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_entity }
        format.html { redirect_to @candy, alert: @review.errors.full_messages.to_sentence }
      end
    end
  end

  def update
    if @review.update(review_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @candy }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :update, status: :unprocessable_entity }
        format.html { redirect_to @candy, alert: @review.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    @review.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @candy }
    end
  end

  private

  def set_candy
    @candy = Candy.find_by!(slug: params[:candy_id])
  end

  def set_review
    @review = @candy.reviews.find(params[:id])
  end

  def review_params
    params.expect(review: %i[rating body])
  end

  def authorize_update!
    return if @review.user_id == Current.user.id
    redirect_to candy_path(@candy), alert: "Not authorized."
  end

  def authorize_destroy!
    return if @review.user_id == Current.user.id || Current.user.admin?
    redirect_to candy_path(@candy), alert: "Not authorized."
  end
end
