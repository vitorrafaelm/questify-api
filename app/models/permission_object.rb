class PermissionObject < ApplicationRecord
  include Discard::Model

  # Constants for object types
  OBJECT_TYPES = %w[
    tests-and-questions
  ].freeze

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :identifier, presence: true, uniqueness: true
  validates :object_type, presence: true, inclusion: { in: OBJECT_TYPES }

  # Scopes
  scope :active, -> { kept }
  scope :by_type, ->(type) { where(object_type: type) }
  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }

  has_many :user_permissions
  has_many :user_authorizations, through: :user_permissions
end
