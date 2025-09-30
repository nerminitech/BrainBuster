class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @categories = Category.order(:name).includes(:questions)
  end

  def show
    @category = Category.find(params[:id])
    @questions = @category.questions.includes(:answer_options)
  end
end
