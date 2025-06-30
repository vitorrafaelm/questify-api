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

  # Scopes
  scope :active, -> { kept }
  scope :by_institution, ->(institution) { where(institution: institution) }

  private

  def generate_identifier
    self.identifier = "EDU-#{SecureRandom.uuid}"
  end
end
