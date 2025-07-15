class AssessmentAnswer < ApplicationRecord
  # Associations
  belongs_to :assessment_by_student
  belongs_to :question
  belongs_to :question_alternative, optional: true # optional for descriptive questions

  # Validations
  validates :assessment_by_student_id, uniqueness: { scope: :question_id, message: "answer for this question already exists" }

  #callback
  before_create :set_correctness_for_multiple_choice
  private

  def set_correctness_for_multiple_choice
    # Verifica se a resposta é para uma questão de múltipla escolha e se uma alternativa foi selecionada
    if question.question_type == 'multiple_choice' && question_alternative_id.present?
      self.is_correct = question_alternative.is_correct
    end
  end
end