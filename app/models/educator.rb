class Educator < ActiveRecord::Base
  include Discard::Model

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :institution, presence: true, length: { maximum: 100 }
  validates :document_type, presence: true, inclusion: { in: %w[CPF CNPJ RG] }
  validates :document_number, presence: true, uniqueness: { scope: :document_type }
  validates :identifier, uniqueness: true, allow_nil: true

  # Callbacks
  before_create :generate_identifier
  after_create :assign_default_permissions

  # Scopes
  scope :active, -> { kept }
  scope :by_institution, ->(institution) { where(institution: institution) }

  #FK
  has_one :user_authorization, as: :user_authorizable, dependent: :destroy
  private

  def generate_identifier
    self.identifier = "EDU-#{SecureRandom.uuid}"
  end

  def assign_default_permissions
    associated_auth = self.user_authorization || UserAuthorization.find_by(user_authorizable: self)

    return unless associated_auth

    educator_permission_identifiers = [
      'create-questions',
      'create-themes',
      'create-assessments',
      'create-classes',
      'manage-classes',
      'view-private-questions'
    ]

    permissions_to_grant = PermissionObject.kept.where(identifier: educator_permission_identifiers)

    permissions_to_grant.each do |permission_obj|
      UserPermission.grant_permission(associated_auth, permission_obj)
    end
  end
end
