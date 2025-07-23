class Api::V1::AssessmentsController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :require_educator_for_create!, only: [:create, :add_question, :assign_to_class_group]
  before_action :set_assessment, only: [:show, :with_questions, :add_question, :add_students, :assign_to_class_group, :remove_student, :remove_question]

  # GET /api/v1/assessments
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    @assessments = current_user.user_authorizable.assessments
                              .order(created_at: :desc)
                              .limit(per_page)
                              .offset((page.to_i - 1) * per_page.to_i)

    total_count = current_user.user_authorizable.assessments.count
    total_pages = (total_count / per_page.to_f).ceil

    render json: Questify::AssessmentSerializer.new(@assessments).sanitized_hash, status: :ok
  end

  # POST /api/v1/assessments
  def create
    ActiveRecord::Base.transaction do
      assessment = {
        title: assessment_params[:title],
        description: assessment_params[:description],
      }
      @assessment = current_user.user_authorizable.assessments.new(assessment)

      if @assessment.save
        if assessment_params[:questions].present?
          questions = Question.where(id: assessment_params[:questions])
          @assessment.questions = questions
        end

        render json: Questify::AssessmentSerializer.new(@assessment).sanitized_hash, status: :created
      else
        render json: { errors: @assessment.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  # GET /api/v1/assessments/:id
  # Mostra os detalhes de uma avaliação, SEM as questões.
  def show
    render json: Questify::AssessmentSerializer.new(@assessment).serializable_hash, status: :ok
  end

  # GET /api/v1/assessments/:id/with_questions
  # Mostra os detalhes de uma avaliação, COM as questões incluídas.
  def with_questions
    render json: Questify::AssessmentSerializer.new(@assessment).sanitized_hash, status: :ok
  end

  # POST /api/v1/assessments/:id/add_question
  def add_question
    questions = Question.where(id: params[:assessment][:questions])
    questions.each do |question|
      @assessment.questions << question unless @assessment.questions.include?(question)
    end

    render json: Questify::AssessmentSerializer.new(@assessment).sanitized_hash, status: :ok
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

  # POST /api/v1/assessments/:id/add_students
  def add_students
    student_ids = params[:assessment][:students] || []
    students = Student.where(identifier: student_ids)
    students.each do |student|
      @assessment.students << student unless @assessment.students.include?(student)
    end
    render json: Questify::AssessmentSerializer.new(@assessment).sanitized_hash, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Aluno não encontrado" }, status: :not_found
  end

  # DELETE /api/v1/assessments/:id/remove_student
  def remove_student
    student = Student.find_by(identifier: params[:student_id])
    if student && @assessment.students.delete(student)
      head :no_content
    else
      render json: { error: "Aluno não encontrado ou não está associado à avaliação" }, status: :not_found
    end
  end

  # DELETE /api/v1/assessments/:id/remove_question/:question_id
  def remove_question
    question = Question.find_by(id: params[:question_id])
    if question && @assessment.questions.delete(question)
      head :no_content
    else
      render json: { error: "Questão não encontrada ou não está associada à avaliação" }, status: :not_found
    end
  end

  private

  def assessment_params
    params.require(:assessment).permit(:title, :description, questions: [])
  end

  # ATUALIZADO COM DEPURAÇÃO E TRATAMENTO DE ERRO
  def set_assessment
    if current_user.user_authorizable.is_a?(Educator)
      # Educators can only access their own assessments
      @assessment = current_user.user_authorizable.assessments.includes(
        questions: :question_alternatives,
        assessment_by_students: :student
      ).find(params[:id])
    else
      # Students can access assessments assigned to their class groups
      student_class_group_ids = current_user.user_authorizable.student_in_class_groups.pluck(:class_group_id)
      @assessment = Assessment.joins(:assessment_to_class_groups)
                             .where(assessment_to_class_groups: { class_group_id: student_class_group_ids })
                             .includes(questions: :question_alternatives)
                             .find(params[:id])
    end

    # Se a avaliação não for encontrada, retorna um erro 404
    if @assessment.nil?
      render json: { error: "Avaliação não encontrada ou não pertence a este usuário" }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Avaliação não encontrada ou não pertence a este usuário" }, status: :not_found
  end

  def require_educator_for_create!
    unless current_user.user_authorizable.is_a?(Educator)
      render json: { error: 'Acesso não autorizado' }, status: :forbidden
    end
  end

  def require_educator!
    unless current_user.user_authorizable.is_a?(Educator)
      render json: { error: 'Acesso não autorizado' }, status: :forbidden
    end
  end
end
