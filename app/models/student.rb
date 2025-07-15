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

  # Scopes
  scope :active, -> { kept }
  scope :by_institution, ->(institution) { where(institution: institution) }
  scope :by_grade, ->(grade) { where(grade: grade) }
  scope :by_username, ->(username) { where("username ILIKE ?", "%#{username}%") }

  has_one :user_authorization, as: :user_authorizable, dependent: :destroy
  has_many :student_in_class_groups, dependent: :destroy
  has_many :class_groups, through: :student_in_class_groups
  has_many :assessment_by_students, dependent: :destroy

  private

  def generate_identifier
    self.identifier = "STU-#{SecureRandom.uuid}"
  end

  def normalize_username
    self.username = username&.downcase&.strip
  end

 
end
