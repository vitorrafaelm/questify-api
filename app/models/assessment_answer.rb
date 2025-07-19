class AssessmentAnswer < ApplicationRecord
  # Associations
  belongs_to :assessment_by_student
  belongs_to :question
  belongs_to :question_alternative, optional: true # optional for descriptive questions

  # Validations
  validates :assessment_by_student_id, uniqueness: { scope: :question_id, message: "answer for this question already exists" }
end