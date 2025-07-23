class Api::V1::StudentsController < Api::V1::BaseController
  before_action :authenticate_user!
  # GET /api/v1/students
  def index
    students = Student.all.order(:name)
    render json: Questify::StudentSerializer.new(students).sanitized_hash, status: :ok
  end
end
