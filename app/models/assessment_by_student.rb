class AssessmentByStudent < ApplicationRecord
  include Discard::Model

  # Associations
  belongs_to :student
  belongs_to :assessment
  has_many :assessment_answers, dependent: :destroy

  # Validations
  validates :student_id, uniqueness: { scope: :assessment_id, message: "student has already started this assessment" }
  validates :status, inclusion: { in: %w[not_started in_progress submitted graded] }

  # Scopes
  scope :active, -> { kept }
end
