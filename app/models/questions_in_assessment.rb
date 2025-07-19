class QuestionsInAssessment < ApplicationRecord
  # Associations
  belongs_to :question
  belongs_to :assessment

  # Validations
  validates :question_id, uniqueness: { scope: :assessment_id, message: "question is already in this assessment" }
end