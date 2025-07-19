class StudentInClassGroup < ApplicationRecord
  # Associations
  belongs_to :student
  belongs_to :class_group

  # Validations
  validates :student_id, uniqueness: { scope: :class_group_id, message: "student is already in this class" }
end