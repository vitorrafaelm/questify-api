class Student < ApplicationRecord
  include Discard::Model

  # Constants
  DOCUMENT_TYPES = %w[CPF RG].freeze

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50 }
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers and underscores" }
  validates :institution, presence: true, length: { maximum: 100 }
  validates :document_type, presence: true, inclusion: { in: DOCUMENT_TYPES }
  validates :document_number, presence: true, uniqueness: { scope: :document_type }
  validates :identifier, uniqueness: true, allow_nil: true

  # Callbacks
  before_create :generate_identifier
  before_validation :normalize_username
  after_create :assign_default_permissions

  # Scopes
  scope :active, -> { kept }
  scope :by_institution, ->(institution) { where(institution: institution) }
  scope :by_grade, ->(grade) { where(grade: grade) }
  scope :by_username, ->(username) { where("username ILIKE ?", "%#{username}%") }

  has_one :user_authorization, as: :user_authorizable, dependent: :destroy

  private

  def generate_identifier
    self.identifier = "STU-#{SecureRandom.uuid}"
  end

  def normalize_username
    self.username = username&.downcase&.strip
  end

  def assign_default_permissions
    associated_auth = self.user_authorization || UserAuthorization.find_by(user_authorizable: self)  
    return unless associated_auth

    student_permission_identifiers = [
      'list-assessments',
      'list-public-questions'
    ]

    permissions_to_grant = PermissionObject.kept.where(identifier: student_permission_identifiers)

    permissions_to_grant.each do |permission_obj|
      UserPermission.grant_permission(associated_auth, permission_obj)
    end
  end
end
