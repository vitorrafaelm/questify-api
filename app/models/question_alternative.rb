class QuestionAlternative < ApplicationRecord
  include Discard::Model

  # Associations
  belongs_to :question

  # Validations
  validates :sentence, presence: true

  # Scopes
  scope :active, -> { kept }
  scope :correct, -> { where(is_correct: true) }
end