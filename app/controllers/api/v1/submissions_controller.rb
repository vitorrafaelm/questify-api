class Api::V1::SubmissionsController < Api::V1::BaseController
  before_action :require_educator!
  before_action :set_submission, only: [:show, :grade]

  # GET /api/v1/submissions/:id
  # Mostra a submissão de um aluno, com todas as suas respostas.
  def show
    options = { include: ['assessment_answers'] }
    render json: Questify::AssessmentByStudentSerializer.new(@submission, options).serializable_hash, status: :ok
  end

  # PATCH /api/v1/submissions/:id/grade
  # Permite que um professor atribua uma nota final a uma submissão.
  def grade
    if @submission.update(score: params[:score])
      @submission.update(status: 'graded')
      render json: Questify::AssessmentByStudentSerializer.new(@submission).serializable_hash, status: :ok
    else
      render json: { errors: @submission.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_submission
    # Encontra a submissão pelo seu ID para garantir que o professor tenha acesso.
    @submission = AssessmentByStudent.find(params[:id])
    
    educator_owns_assessment = @submission.assessment_to_class_group.assessment.educator == current_user.user_authorizable
    render json: { error: 'Acesso não autorizado' }, status: :forbidden unless educator_owns_assessment
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Submissão não encontrada." }, status: :not_found
  end

  def require_educator!
    unless current_user.user_authorizable.is_a?(Educator)
      render json: { error: 'Acesso não autorizado' }, status: :forbidden
    end
  end
end