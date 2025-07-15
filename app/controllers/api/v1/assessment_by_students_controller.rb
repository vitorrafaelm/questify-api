class Api::V1::AssessmentByStudentsController < Api::V1::BaseController
  before_action :require_student!
  before_action :set_assessment_attempt, only: [:submit]

  # GET /api/v1/assessment_by_students
  def index
    # Encontra todas as turmas em que o aluno está.
    class_group_ids = current_user.user_authorizable.class_group_ids

    # Encontra todas as avaliações atribuídas a essas turmas.
    assigned_assessments = AssessmentToClassGroup.where(class_group_id: class_group_ids).includes(assessment: :questions)

    @assessment_attempts = assigned_assessments.map do |assignment|
      AssessmentByStudent.find_or_create_by(
        student: current_user.user_authorizable,
        assessment_to_class_group: assignment
      )
    end

    render json: Questify::AssessmentByStudentSerializer.new(@assessment_attempts).serializable_hash, status: :ok
  end

  # POST /api/v1/assessment_by_students/:id/submit
  def submit
    if @assessment_attempt.status == 'submitted'
      return render json: { error: 'Esta avaliação já foi submetida.' }, status: :unprocessable_entity
    end

    # Usa uma transação para garantir que todas as respostas são salvas ou nenhuma é.
    ActiveRecord::Base.transaction do
      @assessment_attempt.update!(status: 'in_progress')
      
      # Cria cada resposta enviada
      answers_params[:answers].each do |answer_data|
        @assessment_attempt.assessment_answers.create!(
          question_id: answer_data[:question_id],
          question_alternative_id: answer_data[:question_alternative_id],
          answer_text: answer_data[:answer_text]
        )
      end
      
      @assessment_attempt.update!(status: 'submitted')
    end

    head :no_content
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def set_assessment_attempt
    @assessment_attempt = current_user.user_authorizable.assessment_by_students.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Tentativa de avaliação não encontrada." }, status: :not_found
  end

  def answers_params
    params.require(:assessment_submission).permit(answers: [:question_id, :question_alternative_id, :answer_text])
  end

  def require_student!
    unless current_user.user_authorizable.is_a?(Student)
      render json: { error: 'Acesso não autorizado' }, status: :forbidden
    end
  end
end