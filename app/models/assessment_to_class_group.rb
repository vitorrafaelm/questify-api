class AssessmentToClassGroup < ApplicationRecord
  include Discard::Model

  # Associations
  belongs_to :assessment
  belongs_to :class_group
  has_many :assessment_by_students, dependent: :destroy

  # Validations
  validates :assessment_id, uniqueness: { scope: :class_group_id, message: "assessment is already assigned to this class" }
  validates :due_date, presence: true

  # Scopes
  scope :active, -> { kept }
end