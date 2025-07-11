class UserPermission < ApplicationRecord
  include Discard::Model

  belongs_to :user_authorization
  belongs_to :permission_object

  validates :user_authorization_id, presence: true
  validates :permission_object_id, presence: true
  validates :is_active, inclusion: { in: [true, false] }

  validates :user_authorization_id, uniqueness: {
    scope: :permission_object_id,
    message: "already has this permission"
  }

  # Validate that user authorization is active and can have permissions
  validate :user_authorization_must_be_active
  validate :permission_object_must_be_active

  #scope
  scope :active, -> { where(is_active: true) }

  # Class methods
  def self.grant_permission(user_authorization, permission_object)
    permission = find_or_initialize_by(
      user_authorization: user_authorization,
      permission_object: permission_object
    )
    permission.is_active = true
    permission.save!
    permission
  end

  def self.revoke_permission(user_authorization, permission_object)
    permission = find_by(
      user_authorization: user_authorization,
      permission_object: permission_object
    )
    return false unless permission

    permission.is_active = false
    permission.save!
  end

  def self.has_permission?(user_authorization, permission_object)
    active.exists?(
      user_authorization: user_authorization,
      permission_object: permission_object
    )
  end

  private

  def user_authorization_must_be_active
    return unless user_authorization

    unless user_authorization.can_login?
      errors.add(:user_authorization, "must be active to receive permissions")
    end
  end

  def permission_object_must_be_active
    return unless permission_object

    unless permission_object.kept?
      errors.add(:permission_object, "must be active")
    end
  end
end
