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

  # Scopes
  scope :active, -> { kept }
  scope :public_questions, -> { where(is_public: true) }
  scope :private_questions, -> { where(is_public: false) }

  # Nested Attributes
  accepts_nested_attributes_for :question_alternatives, allow_destroy: true
end