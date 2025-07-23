class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :authenticate_user!

  # GET /api/v1/questions
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    if current_user.user_authorizable.is_a?(Student)
      @questions = Question.public_questions
    else
      @questions = Question.all
    end

    @questions = @questions.order(:title).limit(per_page).offset((page.to_i - 1) * per_page.to_i)

    render json:  Questify::QuestionSerializer.new(@questions).sanitized_hash, status: :ok
  end

  # POST /api/v1/questions
  def create
    # Verifica se o usuário tem permissão para criar questões
    unless current_user.has_permission?('create-questions')
      render json: { error: 'Acesso não autorizado' }, status: :forbidden
      return
    end

    @question = Question.new(question_params)
    @question.educator = current_user.user_authorizable

    if @question.question_type == 'descriptive'
      @question.question_alternatives = []
    end

    if @question.save
      render json: Questify::QuestionSerializer.new(@question).serializable_hash, status: :created
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/questions/:id
  def show
    if current_user.user_authorizable.is_a?(Student)
      question = Question.public_questions.find_by(id: params[:id])
    else
      question = Question.where(educator: current_user.user_authorizable).find_by(id: params[:id])
    end

    if question
      render json: Questify::QuestionSerializer.new(question).sanitized_hash, status: :ok
    else
      render json: { error: 'Questão não encontrada ou não autorizada' }, status: :not_found
    end
  end

  # PATCH/PUT /api/v1/questions/:id
  def update
    @question = Question.find_by(id: params[:id])
    unless @question && @question.educator == current_user.user_authorizable
      render json: { error: 'Questão não encontrada ou não autorizada' }, status: :not_found
      return
    end

    if @question.update(question_params)
      render json: Questify::QuestionSerializer.new(@question).sanitized_hash, status: :ok
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
