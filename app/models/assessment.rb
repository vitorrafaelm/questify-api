class Assessment < ApplicationRecord
  include Discard::Model

  # Associations
  belongs_to :educator
  has_many :questions_in_assessments, dependent: :destroy
  has_many :questions, through: :questions_in_assessments
  has_many :assessment_to_class_groups, dependent: :destroy
  has_many :class_groups, through: :assessment_to_class_groups
  has_many :assessment_by_students, dependent: :destroy
  has_many :students, through: :assessment_by_students

  # Validations
  validates :title, presence: true, length: { maximum: 255 }

  # Scopes
  scope :active, -> { kept }
end
