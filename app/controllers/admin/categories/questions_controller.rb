module Admin
  module Categories
    class QuestionsController < BaseController
      before_action :set_category

      def create
        @question = @category.questions.build(question_params)
        build_missing_answers(@question)

        if @question.save
          redirect_to admin_category_path(@category), notice: "Frage wurde hinzugefügt."
        else
          @questions = @category.questions.order(:created_at)
          @new_question = prepare_new_question(@question)
          render "admin/categories/show", status: 422
        end
      end

      private

      def set_category
        @category = Category.find(params[:category_id])
      end

      def question_params
        params.require(:question).permit(
          :content,
          :explanation,
          :difficulty,
          :time_limit_seconds,
          :base_points,
          :source_url,
          :language,
          answer_options_attributes: %i[id text correct position _destroy]
        ).tap do |permitted|
          permitted[:language] = permitted[:language].presence || "de"
        end
      end

      def prepare_new_question(question = nil)
        question ||= @category.questions.build(language: "de", difficulty: "mittel", time_limit_seconds: 30, base_points: 100)
        build_missing_answers(question)
        question
      end

      def build_missing_answers(question)
        existing = question.answer_options.size
        (existing...4).each do |position|
          question.answer_options.build(position: position)
        end
      end
    end
  end
end
