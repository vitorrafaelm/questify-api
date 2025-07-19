class ClassGroup < ApplicationRecord
  include Discard::Model

  # Associations
  has_many :student_in_class_groups, dependent: :destroy
  has_many :students, through: :student_in_class_groups
  has_many :assessment_to_class_groups, dependent: :destroy
  has_many :assessments, through: :assessment_to_class_groups

  # Validations
  validates :name, presence: true, length: { maximum: 150 }
  validates :class_identifier, presence: true, uniqueness: { scope: :period }
  validates :period, presence: true

  # Scopes
  scope :active, -> { kept }
end