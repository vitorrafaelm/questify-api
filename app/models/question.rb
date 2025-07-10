class Question < ApplicationRecord
  include Discard::Model

  # Associations
  belongs_to :educator
  has_and_belongs_to_many :themes
  has_many :question_alternatives, dependent: :destroy
  has_many :questions_in_assessments, dependent: :destroy
  has_many :assessments, through: :questions_in_assessments

  # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 255 }
  validates :content, presence: true
  validates :question_type, presence: true, inclusion: { in: %w[multiple_choice descriptive] }
  validate :validate_alternatives_count, if: :multiple_choice?
  # Scopes
  scope :active, -> { kept }
  scope :public_questions, -> { where(is_public: true) }
  scope :private_questions, -> { where(is_public: false) }

  # Nested Attributes
  accepts_nested_attributes_for :question_alternatives, allow_destroy: true

  def multiple_choice?
    question_type == 'multiple_choice'
  end

  # Lógica da validação customizada
  def validate_alternatives_count
    # Filtra as alternativas que não estão marcadas para serem destruídas
    active_alternatives = question_alternatives.reject(&:marked_for_destruction?)

    # Verifica se o número de alternativas ativas está entre 2 e 5
    unless (2..5).cover?(active_alternatives.size)
      errors.add(:base, "Questões de múltipla escolha devem ter entre 2 e 5 alternativas.")
    end
  end
end