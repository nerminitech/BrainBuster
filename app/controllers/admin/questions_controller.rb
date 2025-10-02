module Admin
  class QuestionsController < BaseController
    before_action :set_question, only: %i[show edit update destroy]
    before_action :set_categories, only: %i[new edit]

    def index
      @questions = Question.includes(:category).order(created_at: :desc)
    end

    def show; end

    def new
      @question = Question.new
      4.times { @question.answer_options.build }
    end

    def edit
      (4 - @question.answer_options.size).times { @question.answer_options.build }
    end

    def create
      @question = Question.new(question_params)
      if @question.save
        redirect_to admin_question_path(@question), notice: "Frage wurde erstellt."
      else
        set_categories
        render :new, status: 422
      end
    end

    def update
      if @question.update(question_params)
        redirect_to admin_question_path(@question), notice: "Frage wurde aktualisiert."
      else
        set_categories
        render :edit, status: 422
      end
    end

    def destroy
      @question.destroy
      redirect_to admin_questions_path, notice: "Frage wurde gelöscht."
    end

    private

    def set_question
      @question = Question.find(params[:id])
    end

    def set_categories
      @categories = Category.order(:name)
    end

    def question_params
      params.require(:question).permit(
        :category_id,
        :content,
        :explanation,
        :difficulty,
        :time_limit_seconds,
        :base_points,
        :source_url,
        :language,
        answer_options_attributes: %i[id text correct position _destroy]
      )
    end
  end
end
