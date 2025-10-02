module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: %i[show edit update destroy]

    def index
      @categories = Category.order(:name)
    end

    def show
      @questions = @category.questions.order(:created_at)
      @new_question = prepare_new_question
    end

    def new
      @category = Category.new
    end

    def edit; end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_category_path(@category), notice: "Kategorie wurde erstellt."
      else
        render :new, status: 422
      end
    end

    def update
      if @category.update(category_params)
        redirect_to admin_category_path(@category), notice: "Kategorie wurde aktualisiert."
      else
        render :edit, status: 422
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: "Kategorie wurde gelöscht."
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description, :featured)
    end

    def prepare_new_question(question = nil)
      question ||= @category.questions.build(language: "de", difficulty: "mittel", time_limit_seconds: 30, base_points: 100)
      existing = question.answer_options.size
      (existing...4).each do |position|
        question.answer_options.build(position: position)
      end
      question
    end
  end
end
