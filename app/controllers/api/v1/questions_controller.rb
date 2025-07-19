class Api::V1::QuestionsController < Api::V1::BaseController
  # GET /api/v1/questions
  def index
    if current_user.user_authorizable.is_a?(Student)
      # Alunos veem apenas questões públicas
      @questions = Question.public_questions.active.includes(:themes, :question_alternatives)
    else
      # Professores veem todas as questões
      @questions = Question.all.active.includes(:themes, :question_alternatives)
    end

    render json: Questify::QuestionSerializer.new(@questions).serializable_hash, status: :ok
  end

  # POST /api/v1/questions
  def create
    # Verifica se o usuário tem permissão para criar questões
    unless current_user.has_permission?('create-questions')
      render json: { error: 'Acesso não autorizado' }, status: :forbidden
      return
    end

    @question = Question.new(question_params)
    # Associa a questão ao professor que está logado
    @question.educator = current_user.user_authorizable

    if @question.save
      render json: Questify::QuestionSerializer.new(@question).serializable_hash, status: :created
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    # Permite os parâmetros para a questão, incluindo os temas associados
    # e as alternativas aninhadas.
    params.require(:question).permit(
      :title,
      :content,
      :is_public,
      :question_type,
      theme_ids: [],
      question_alternatives_attributes: [:id, :sentence, :is_correct, :_destroy]
    )
  end
end