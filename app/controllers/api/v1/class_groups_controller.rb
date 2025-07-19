class Api::V1::ClassGroupsController < Api::V1::BaseController
  before_action :require_educator!, only: [:create, :add_student]
  before_action :set_class_group, only: [:show, :with_students, :add_student]

  # GET /api/v1/class_groups
  # Lista as turmas. Para professores, lista todas. Para alunos, as que estão matriculados.
  def index
    if current_user.user_authorizable.is_a?(Educator)
      @class_groups = ClassGroup.active
    else
      @class_groups = current_user.user_authorizable.class_groups.active
    end
    render json: Questify::ClassGroupSerializer.new(@class_groups).serializable_hash, status: :ok
  end

  # GET /api/v1/class_groups/:id
  # Mostra os detalhes de uma turma, SEM a lista de alunos.
  def show
    render json: Questify::ClassGroupSerializer.new(@class_group).serializable_hash, status: :ok
  end

  # GET /api/v1/class_groups/:id/with_students
  # Mostra os detalhes de uma turma, COM a lista de alunos paginada.
  def with_students
    @paginated_students = @class_group.students.page(params[:page])

    options = {
      include: [:students],
      meta: {
        total_pages: @paginated_students.total_pages,
        current_page: @paginated_students.current_page,
        next_page: @paginated_students.next_page,
        prev_page: @paginated_students.prev_page,
        total_count: @paginated_students.total_count
      }
    }

    render json: Questify::ClassGroupSerializer.new(@class_group, options).serializable_hash, status: :ok
  end

  # POST /api/v1/class_groups
    def create
    @class_group = ClassGroup.new(class_group_params)
    @class_group.educator = current_user.user_authorizable

    if @class_group.save
      render json: Questify::ClassGroupSerializer.new(@class_group).serializable_hash, status: :created
    else
      render json: { errors: @class_group.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/class_groups/:id/add_student
  def add_student
    student = Student.find(params[:student_id])
    @class_group.students << student unless @class_group.students.include?(student)

    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Aluno não encontrado" }, status: :not_found
  end

  private

  def class_group_params
    params.require(:class_group).permit(:name, :description, :class_identifier, :period)
  end

  def set_class_group
    @class_group = ClassGroup.find(params[:id])
  end

  def require_educator!
    unless current_user.user_authorizable.is_a?(Educator)
      render json: { error: 'Acesso não autorizado' }, status: :forbidden
    end
  end
end
