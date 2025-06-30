class UserAuthorization < ApplicationRecord
  include Discard::Model
  include AASM

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :encrypted_password, presence: true
  validates :identifier, uniqueness: true, allow_nil: true
  validate :password_complexity

  before_create :generate_identifier

  devise :database_authenticatable, :registerable, :recoverable
  belongs_to :user_authorizable, polymorphic: true
  has_many :user_permissions
  has_many :permission_objects, through: :user_permissions

  # State machine definition
  aasm column: :state do
    state :pending, initial: true
    state :active
    state :suspended
    state :locked
    state :password_reset_required

    event :activate do
      transitions from: [:pending, :suspended, :password_reset_required], to: :active, after: :set_previous_state
    end

    event :suspend do
      transitions from: [:active, :pending], to: :suspended, after: :set_previous_state
    end

    event :lock do
      transitions from: [:active, :pending, :suspended], to: :locked, after: :set_previous_state
    end

    event :unlock do
      transitions from: :locked, to: :active, after: :set_previous_state
    end

    event :require_password_reset do
      transitions from: [:active, :pending], to: :password_reset_required, after: :set_previous_state
    end
  end

  # Scopes
  scope :for_educators, -> { where(user_authorizable_type: 'Educator') }
  scope :for_students, -> { where(user_authorizable_type: 'Student') }

  # Class methods
  def self.authenticate(email, password)
    user = find_by(email: email.downcase.strip)
    return nil unless user&.authenticate(password)
    return nil unless user.can_login?
    user
  end

  def password_complexity
    # Testing capital letters          (?=.*?[A-Z])
    # Testing small letters            (?=.*?[a-z])
    # Testing numbers                 (?=.*?[0-9])
    # Testing special character    (?=.*?[#?!@$%^&*-])
    # Testing sequences              (?!.*(012|123|234|345|456|567|678|789))
    # Testing reversal sequences (?!.*(210|321|432|543|654|765|876|987))
    # Testing string's length        {6,}
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])(?!.*(012|123|234|345|456|567|678|789))(?!.*(210|321|432|543|654|765|876|987)).{6,}$/
    errors.add :password, "complexity not met."
  end

  # Instance methods
  def can_login?
    active? && kept?
  end

  def generate_password_reset_token!
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.current
    save!
  end

  def password_reset_token_valid?
    reset_password_sent_at && reset_password_sent_at > 2.hours.ago
  end

  def clear_password_reset_token!
    self.reset_password_token = nil
    self.reset_password_sent_at = nil
    save!
  end

  def set_previous_state
    self.previous_state = aasm.from_state
    return
  end

  private

  def generate_identifier
    self.identifier = "AUTH-#{SecureRandom.uuid}"
  end
end
