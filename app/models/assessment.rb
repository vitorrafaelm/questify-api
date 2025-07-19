class Assessment < ApplicationRecord
  include Discard::Model

  # Associations
  belongs_to :educator
  has_many :questions_in_assessments, dependent: :destroy
  has_many :questions, through: :questions_in_assessments
  has_many :assessment_to_class_groups, dependent: :destroy
  has_many :class_groups, through: :assessment_to_class_groups

  # Validations
  validates :title, presence: true, length: { maximum: 255 }

  # Scopes
  scope :active, -> { kept }
end