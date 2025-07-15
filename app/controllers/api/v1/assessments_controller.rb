class Api::V1::AssessmentsController < Api::V1::BaseController
  before_action :require_educator!
  before_action :set_assessment, only: [:show, :with_questions, :add_question, :assign_to_class_group]

  # POST /api/v1/assessments
  def create
    @assessment = current_user.user_authorizable.assessments.new(assessment_params)

    if @assessment.save
      render json: Questify::AssessmentSerializer.new(@assessment).serializable_hash, status: :created
    else
      render json: { errors: @assessment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/assessments/:id
  # Mostra os detalhes de uma avaliação, SEM as questões.
  def show
    render json: Questify::AssessmentSerializer.new(@assessment).serializable_hash, status: :ok
  end

  # GET /api/v1/assessments/:id/with_questions
  # Mostra os detalhes de uma avaliação, COM as questões incluídas.
  def with_questions
  options = { include: [:'questions.question_alternatives'] }
  render json: Questify::AssessmentSerializer.new(@assessment, options).serializable_hash, status: :ok
end

  # POST /api/v1/assessments/:id/add_question
  def add_question
    question = Question.find(params[:question_id])
    @assessment.questions << question unless @assessment.questions.include?(question)

    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Questão não encontrada" }, status: :not_found
  end

  # POST /api/v1/assessments/:id/assign_to_class_group
  def assign_to_class_group
    class_group = ClassGroup.find(params[:class_group_id])
    
    assignment = @assessment.assessment_to_class_groups.new(
      class_group: class_group,
      due_date: params[:due_date]
    )

    if assignment.save
      head :no_content
    else
      render json: { errors: assignment.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Turma não encontrada" }, status: :not_found
  end

  private

  def assessment_params
    params.require(:assessment).permit(:title, :description)
  end

  # ATUALIZADO COM DEPURAÇÃO E TRATAMENTO DE ERRO
  def set_assessment
    @assessment = current_user.user_authorizable.assessments.includes(questions: :question_alternatives).find(params[:id])

    # Se a avaliação não for encontrada, retorna um erro 404
    if @assessment.nil?
      render json: { error: "Avaliação não encontrada ou não pertence a este usuário" }, status: :not_found
    end
  end

  def require_educator!
    unless current_user.user_authorizable.is_a?(Educator)
      render json: { error: 'Acesso não autorizado' }, status: :forbidden
    end
  end
end
